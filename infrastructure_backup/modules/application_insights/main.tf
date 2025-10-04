# =============================================================================
# MODULE: application_insights
# FILE: infrastructure/terraform/modules/application_insights/main.tf
# =============================================================================

resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  application_type    = var.application_type
  
  tags = var.tags
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
# FILE: infrastructure/terraform/modules/application_insights/main.tf    --- IGNORE ---