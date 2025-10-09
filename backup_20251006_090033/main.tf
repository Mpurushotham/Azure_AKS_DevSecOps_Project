terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"  # Latest stable as of Oct 2024
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstatec264d73c"
    container_name       = "tfstate"
    key                  = "ecommerce.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

# Random suffix for unique names
resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${var.environment}"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# AKS Subnet
resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aks_subnet_address_prefix
  
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Container Registry
resource "azurerm_container_registry" "main" {
  name                = "acr${var.project_name}${var.environment}${random_string.unique.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"  # Changed to Basic for testing
  admin_enabled       = true     # Enable admin for easier testing
  tags                = var.tags
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.project_name}-${random_string.unique.result}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    
    key_permissions         = ["Get", "List", "Create"]
    secret_permissions      = ["Get", "List", "Set", "Delete"]
    certificate_permissions = ["Get", "List", "Create"]
  }
  
  tags = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.project_name}${var.environment}"
  kubernetes_version  = "1.28.3"
  
  default_node_pool {
    name                = "default"
    node_count          = 2  # Reduced for testing
    vm_size             = "Standard_D2s_v3"  # Smaller for cost
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = false
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }
  
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }
  
  tags = var.tags
}

# Role Assignment for ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}
