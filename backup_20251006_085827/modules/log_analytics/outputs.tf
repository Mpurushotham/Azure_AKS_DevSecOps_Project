output "workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}

output "workspace_customer_id" {
  value = azurerm_log_analytics_workspace.main.workspace_id
}
