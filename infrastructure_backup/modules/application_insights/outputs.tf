# FILE: infrastructure/terraform/modules/application_insights/outputs.tf
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
# Output Definitions
output "app_insights_id" {
  description = "ID of the Application Insights"
  value       = azurerm_application_insights.main.id
}
output "app_insights_instrumentation_key" {
    description = "Instrumentation Key of the Application Insights"
    value       = azurerm_application_insights.main.instrumentation_key
    sensitive   = true
    }
output "app_insights_connection_string" {
    description = "Connection String of the Application Insights"
    value       = azurerm_application_insights.main.connection_string
    sensitive   = true
    }
# FILE: infrastructure/terraform/modules/application_insights/outputs.tf    --- IGNORE ---
# =============================================================================