# =============================================================================
# FILE: infrastructure/terraform/terraform.tfvars.example
# Example Terraform Variables File
# Copy this to terraform.tfvars and update with your values
# =============================================================================


# Resource Configuration
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
log_retention_days = 30

# PostgreSQL Configuration
postgres_admin_username        = "psqladmin"
postgres_admin_password        = "YourStrongPassword123!" # Change this!
postgres_sku_name              = "GP_Standard_D4s_v3"
postgres_storage_mb            = 32768
postgres_version               = "14"
postgres_backup_retention_days = 30
postgres_geo_redundant_backup  = true
postgres_ha_enabled            = true

# Tags
tags = {
  Environment = "production"
  ManagedBy   = "Terraform"
  Project     = "ecommerce"
  CostCenter  = "engineering"
}
