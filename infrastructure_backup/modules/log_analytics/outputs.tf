# FILE: infrastructure/terraform/modules/log_analytics/outputs.tf
output "workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}

output "workspace_customer_id" {
  value = azurerm_log_analytics_workspace.main.workspace_id
}
output "primary_shared_key" {
  value     = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive = true
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
output "workspace_customer_id" {
    description = "Customer ID of the Log Analytics Workspace"
    value       = azurerm_log_analytics_workspace.main.workspace
}
output "primary_shared_key" {
    description = "Primary Shared Key of the Log Analytics Workspace"
    value       = azurerm_log_analytics_workspace.main.primary_shared_key
    sensitive   = true
}
# FILE: infrastructure/terraform/modules/log_analytics/outputs.tf    --- IGNORE ---
