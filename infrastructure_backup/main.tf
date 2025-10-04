# =============================================================================
# FILE: infrastructure/terraform/main.tf
# Main Terraform Configuration
# =============================================================================

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate1e6ea0ad"  # Replace with your actual storage account name
    container_name       = "tfstate"
    key                  = "ecommerce.tfstate"
  }
}

provider "azurerm" {
    skip_provider_registration = "true"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Data source for current client config
data "azurerm_client_config" "current" {}

# Random string for unique naming
resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

# Main Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_name           = "vnet-${var.project_name}-${var.environment}"
  address_space       = var.vnet_address_space
  
  subnets = {
    aks = {
      name             = "snet-aks"
      address_prefixes = var.aks_subnet_address_prefix
    }
    database = {
      name             = "snet-database"
      address_prefixes = var.database_subnet_address_prefix
    }
    services = {
      name             = "snet-services"
      address_prefixes = var.services_subnet_address_prefix
    }
  }
  
  tags = var.tags
}

# Log Analytics Workspace
module "log_analytics" {
  source = "./modules/log_analytics"
  
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  workspace_name      = "law-${var.project_name}-${var.environment}"
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  
  tags = var.tags
}

# Application Insights
module "application_insights" {
  source = "./modules/application_insights"
  
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  app_insights_name   = "appi-${var.project_name}-${var.environment}"
  workspace_id        = module.log_analytics.workspace_id
  application_type    = "web"
  
  tags = var.tags
}

# Azure Container Registry
module "acr" {
  source = "./modules/acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  acr_name            = "acr${var.project_name}${var.environment}${random_string.unique.result}"
  sku                 = var.acr_sku
  admin_enabled       = false
  
  # Network rules
  network_rule_set = {
    default_action = "Deny"
    virtual_network_subnet_ids = [
      module.networking.subnet_ids["aks"]
    ]
  }
  
  tags = var.tags
}

# Azure Key Vault
module "keyvault" {
  source = "./modules/keyvault"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  keyvault_name       = "kv-${var.project_name}-${var.environment}-${random_string.unique.result}"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
  
  # Network ACLs
  network_acls = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [
      module.networking.subnet_ids["aks"]
    ]
  }
  
  # Access policies
  access_policies = [
    {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id
      
      key_permissions = [
        "Get", "List", "Create", "Delete", "Update"
      ]
      
      secret_permissions = [
        "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
      ]
      
      certificate_permissions = [
        "Get", "List", "Create", "Delete", "Update"
      ]
    }
  ]
  
  tags = var.tags
}

# Azure Kubernetes Service
module "aks" {
  source = "./modules/aks"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  cluster_name        = "aks-${var.project_name}-${var.environment}"
  dns_prefix          = "${var.project_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version
  
  # System node pool
  default_node_pool = {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = var.system_node_vm_size
    vnet_subnet_id      = module.networking.subnet_ids["aks"]
    enable_auto_scaling = true
    min_count           = var.system_node_min_count
    max_count           = var.system_node_max_count
    os_disk_size_gb     = 128
    type                = "VirtualMachineScaleSets"
  }
  
  # Network profile
  network_profile = {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    service_cidr      = "10.1.0.0/16"
    dns_service_ip    = "10.1.0.10"
  }
  
  # Azure AD RBAC
  azure_active_directory_role_based_access_control = {
    managed                = true
    azure_rbac_enabled     = true
  }
  
  # Monitoring
  oms_agent = {
    log_analytics_workspace_id = module.log_analytics.workspace_id
  }
  
  # ACR integration
  acr_id = module.acr.acr_id
  
  tags = var.tags
}

# User node pool for applications
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = module.aks.cluster_id
  vm_size               = var.user_node_vm_size
  node_count            = var.user_node_count
  enable_auto_scaling   = true
  min_count             = var.user_node_min_count
  max_count             = var.user_node_max_count
  vnet_subnet_id        = module.networking.subnet_ids["aks"]
  os_disk_size_gb       = 256
  
  node_labels = {
    "workload" = "application"
    "environment" = var.environment
  }
  
  tags = var.tags
}

# PostgreSQL Flexible Server
module "postgresql" {
  source = "./modules/postgresql"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  server_name         = "psql-${var.project_name}-${var.environment}"
  
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password
  
  sku_name   = var.postgres_sku_name
  storage_mb = var.postgres_storage_mb
  version    = var.postgres_version
  
  backup_retention_days        = var.postgres_backup_retention_days
  geo_redundant_backup_enabled = var.postgres_geo_redundant_backup
  
  high_availability = {
    mode = var.postgres_ha_enabled ? "ZoneRedundant" : "Disabled"
  }
  
  delegated_subnet_id = module.networking.subnet_ids["database"]
  
  tags = var.tags
}
