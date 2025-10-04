# =============================================================================
# MODULE: log_analytics
# FILE: infrastructure/terraform/modules/log_analytics/main.tf
# =============================================================================

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  
  tags = var.tags
}
# Output Definitions
output "workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.name
}
# FILE: infrastructure/terraform/modules/log_analytics/main.tf    --- IGNORE ---