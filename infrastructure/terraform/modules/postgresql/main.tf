# =============================================================================
# MODULE: postgresql
# FILE: infrastructure/terraform/modules/postgresql/main.tf
# =============================================================================

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
# Output Definitions
output "postgresql_server_id" {
  description = "ID of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.id
}

output "postgresql_server_fqdn" {
  description = "FQDN of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_administrator_login" {
  description = "Administrator login for PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.administrator_login
    sensitive   = true
}
# FILE: infrastructure/terraform/modules/postgresql/main.tf    --- IGNORE ---   