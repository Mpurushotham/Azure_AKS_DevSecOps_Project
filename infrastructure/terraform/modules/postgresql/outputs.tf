# FILE: infrastructure/terraform/modules/postgresql/outputs.tf
# =============================================================================
# MODULE: postgresql

# Output Definitions
output "server_id" {
  description = "ID of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.id
}

output "server_name" {
  value = azurerm_postgresql_flexible_server.main.name
}

output "server_fqdn" {
  description = "FQDN of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "administrator_login" {
  description = "Administrator login for PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.administrator_login
  sensitive   = true
}   
output "database_name" {
  description = "Name of the default database"
  value       = azurerm_postgresql_flexible_server_database.main.name
}
# FILE: infrastructure/terraform/modules/postgresql/outputs.tf    --- IGNORE ---
