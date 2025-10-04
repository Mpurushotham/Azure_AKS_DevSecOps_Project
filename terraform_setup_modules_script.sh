#!/bin/bash

################################################################################
# Terraform Modules Setup Script
# This script creates all Terraform module files in the correct structure
################################################################################

set -e

echo "🚀 Setting up Terraform Modules"
echo "================================"

# Check if we're in the right directory
if [ ! -d "infrastructure/terraform" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    echo "   Expected to find: infrastructure/terraform/"
    exit 1
fi

cd infrastructure/terraform

echo "📁 Creating module directories..."

# Create module directories
mkdir -p modules/{networking,aks,acr,keyvault,log_analytics,application_insights,postgresql}

echo "✅ Module directories created"

################################################################################
# NETWORKING MODULE
################################################################################

echo "📝 Creating Networking module..."

cat > modules/networking/main.tf << 'EOF'
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  
  tags = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
  
  dynamic "delegation" {
    for_each = each.key == "database" ? [1] : []
    content {
      name = "fs"
      service_delegation {
        name = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
        ]
      }
    }
  }
}

resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.subnets["aks"].id
  network_security_group_id = azurerm_network_security_group.aks.id
}
EOF

cat > modules/networking/variables.tf << 'EOF'
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "tags" {
  type = map(string)
}
EOF

cat > modules/networking/outputs.tf << 'EOF'
output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.subnets : k => v.id }
}
EOF

################################################################################
# AKS MODULE
################################################################################

echo "📝 Creating AKS module..."

cat > modules/aks/main.tf << 'EOF'
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  
  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    min_count           = var.default_node_pool.min_count
    max_count           = var.default_node_pool.max_count
    os_disk_size_gb     = var.default_node_pool.os_disk_size_gb
    type                = var.default_node_pool.type
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin    = var.network_profile.network_plugin
    network_policy    = var.network_profile.network_policy
    load_balancer_sku = var.network_profile.load_balancer_sku
    service_cidr      = var.network_profile.service_cidr
    dns_service_ip    = var.network_profile.dns_service_ip
  }
  
  azure_active_directory_role_based_access_control {
    managed            = var.azure_active_directory_role_based_access_control.managed
    azure_rbac_enabled = var.azure_active_directory_role_based_access_control.azure_rbac_enabled
  }
  
  oms_agent {
    log_analytics_workspace_id = var.oms_agent.log_analytics_workspace_id
  }
  
  tags = var.tags
}

resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
EOF

cat > modules/aks/variables.tf << 'EOF'
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "default_node_pool" {
  type = object({
    name                = string
    node_count          = number
    vm_size             = string
    vnet_subnet_id      = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    os_disk_size_gb     = number
    type                = string
  })
}

variable "network_profile" {
  type = object({
    network_plugin    = string
    network_policy    = string
    load_balancer_sku = string
    service_cidr      = string
    dns_service_ip    = string
  })
}

variable "azure_active_directory_role_based_access_control" {
  type = object({
    managed            = bool
    azure_rbac_enabled = bool
  })
}

variable "oms_agent" {
  type = object({
    log_analytics_workspace_id = string
  })
}

variable "acr_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
EOF

cat > modules/aks/outputs.tf << 'EOF'
output "cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}

output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
EOF

################################################################################
# ACR MODULE
################################################################################

echo "📝 Creating ACR module..."

cat > modules/acr/main.tf << 'EOF'
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  
  dynamic "network_rule_set" {
    for_each = var.network_rule_set != null ? [var.network_rule_set] : []
    content {
      default_action = network_rule_set.value.default_action
      
      dynamic "virtual_network" {
        for_each = network_rule_set.value.virtual_network_subnet_ids
        content {
          action    = "Allow"
          subnet_id = virtual_network.value
        }
      }
    }
  }
  
  tags = var.tags
}
EOF

cat > modules/acr/variables.tf << 'EOF'
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Premium"
}

variable "admin_enabled" {
  type    = bool
  default = false
}

variable "network_rule_set" {
  type = object({
    default_action             = string
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "tags" {
  type = map(string)
}
EOF

cat > modules/acr/outputs.tf << 'EOF'
output "acr_id" {
  value = azurerm_container_registry.main.id
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "login_server" {
  value = azurerm_container_registry.main.login_server
}
EOF

################################################################################
# KEY VAULT MODULE
################################################################################

echo "📝 Creating Key Vault module..."

cat > modules/keyvault/main.tf << 'EOF'
resource "azurerm_key_vault" "main" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 90
  purge_protection_enabled   = true
  
  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      default_action             = network_acls.value.default_action
      bypass                     = network_acls.value.bypass
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
  
  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "policies" {
  count = length(var.access_policies)
  
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.access_policies[count.index].tenant_id
  object_id    = var.access_policies[count.index].object_id
  
  key_permissions         = var.access_policies[count.index].key_permissions
  secret_permissions      = var.access_policies[count.index].secret_permissions
  certificate_permissions = var.access_policies[count.index].certificate_permissions
}
EOF

cat > modules/keyvault/variables.tf << 'EOF'
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "premium"
}

variable "network_acls" {
  type = object({
    default_action             = string
    bypass                     = string
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "access_policies" {
  type = list(object({
    tenant_id               = string
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
  default = []
}

variable "tags" {
  type = map(string)
}
EOF

cat > modules/keyvault/outputs.tf << 'EOF'
output "keyvault_id" {
  value = azurerm_key_vault.main.id
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "keyvault_uri" {
  value = azurerm_key_vault.main.vault_uri
}
EOF

################################################################################
# LOG ANALYTICS MODULE
################################################################################

echo "📝 Creating Log Analytics module..."

cat > modules/log_analytics/main.tf << 'EOF'
resource "azurerm_log_analytics_workspace" "main" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  
  tags = var.tags
}
EOF

cat > modules/log_analytics/variables.tf << 'EOF'
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workspace_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "PerGB2018"
}

variable "retention_in_days" {
  type    = number
  default = 90
}

variable "tags" {
  type = map(string)
}
EOF

cat > modules/log_analytics/outputs.tf << 'EOF'
output "workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}

output "workspace_customer_id" {
  value = azurerm_log_analytics_workspace.main.workspace_id
}
EOF

################################################################################
# APPLICATION INSIGHTS MODULE
################################################################################

echo "📝 Creating Application Insights module..."

cat > modules/application_insights/main.tf << 'EOF'
resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  application_type    = var.application_type
  
  tags = var.tags
}
EOF

cat > modules/application_insights/variables.tf << 'EOF'
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "app_insights_name" {
  type = string
}

variable "workspace_id" {
  type = string
}

variable "application_type" {
  type    = string
  default = "web"
}

variable "tags" {
  type = map(string)
}
EOF

cat > modules/application_insights/outputs.tf << 'EOF'
output "app_insights_id" {
  value = azurerm_application_insights.main.id
}

output "app_insights_name" {
  value = azurerm_application_insights.main.name
}

output "instrumentation_key" {
  value     = azurerm_application_insights.main.instrumentation_key
  sensitive = true
}

output "connection_string" {
  value     = azurerm_application_insights.main.connection_string
  sensitive = true
}
EOF

################################################################################
# POSTGRESQL MODULE
################################################################################

echo "📝 Creating PostgreSQL module..."

cat > modules/postgresql/main.tf << 'EOF'
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.version
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  
  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  
  delegated_subnet_id = var.delegated_subnet_id
  
  dynamic "high_availability" {
    for_each = var.high_availability.mode != "Disabled" ? [var.high_availability] : []
    content {
      mode = high_availability.value.mode
    }
  }
  
  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "ecommerce"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
EOF

cat > modules/postgresql/variables.tf << 'EOF'
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "server_name" {
  type = string
}

variable "administrator_login" {
  type      = string
  sensitive = true
}

variable "administrator_password" {
  type      = string
  sensitive = true
}

variable "sku_name" {
  type = string
}

variable "storage_mb" {
  type = number
}

variable "version" {
  type = string
}

variable "backup_retention_days" {
  type = number
}

variable "geo_redundant_backup_enabled" {
  type = bool
}

variable "high_availability" {
  type = object({
    mode = string
  })
}

variable "delegated_subnet_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
EOF

cat > modules/postgresql/outputs.tf << 'EOF'
output "server_id" {
  value = azurerm_postgresql_flexible_server.main.id
}

output "server_name" {
  value = azurerm_postgresql_flexible_server.main.name
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "administrator_login" {
  value     = azurerm_postgresql_flexible_server.main.administrator_login
  sensitive = true
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.main.name
}
EOF

################################################################################
# CREATE terraform.tfvars FILE
################################################################################

echo "📝 Creating terraform.tfvars example..."

cat > terraform.tfvars.example << 'EOF'
# Azure Configuration
resource_group_name = "rg-ecommerce-prod"
location            = "eastus"
project_name        = "ecommerce"
environment         = "prod"

# Networking
vnet_address_space             = ["10.0.0.0/16"]
aks_subnet_address_prefix      = ["10.0.1.0/24"]
database_subnet_address_prefix = ["10.0.2.0/24"]
services_subnet_address_prefix = ["10.0.3.0/24"]

# AKS Configuration
kubernetes_version    = "1.28.3"
system_node_count     = 3
system_node_vm_size   = "Standard_D4s_v3"
system_node_min_count = 3
system_node_max_count = 10

user_node_count     = 3
user_node_vm_size   = "Standard_D8s_v3"
user_node_min_count = 3
user_node_max_count = 20

# ACR Configuration
acr_sku = "Premium"

# Log Analytics
log_retention_days = 90

# PostgreSQL Configuration
postgres_admin_username        = "psqladmin"
postgres_admin_password        = "ChangeMe123!"
postgres_sku_name              = "GP_Standard_D4s_v3"
postgres_storage_mb            = 32768
postgres_version               = "14"
postgres_backup_retention_days = 35
postgres_geo_redundant_backup  = true
postgres_ha_enabled            = true

# Tags
tags = {
  Environment = "production"
  ManagedBy   = "Terraform"
  Project     = "ecommerce"
}
EOF

echo ""
echo "✅ All Terraform modules created successfully!"
echo ""
echo "📊 Summary:"
echo "   • Networking module: ✅"
echo "   • AKS module: ✅"
echo "   • ACR module: ✅"
echo "   • Key Vault module: ✅"
echo "   • Log Analytics module: ✅"
echo "   • Application Insights module: ✅"
echo "   • PostgreSQL module: ✅"
echo ""
echo "📝 Next steps:"
echo "   1. Copy terraform.tfvars.example to terraform.tfvars"
echo "   2. Update terraform.tfvars with your values"
echo "   3. Run: terraform init"
echo "   4. Run: terraform plan"
echo "   5. Run: terraform apply"
echo ""
echo "💡 Tip: Make sure you've run 'az login' and set your subscription"
echo ""echo "🚀 Happy Terraforming!"
echo "================================"
echo ""
# End of script

