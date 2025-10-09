# =============================================================================
# FILE: infrastructure/terraform/outputs.tf
# Output Definitions
# =============================================================================

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Networking Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = module.networking.subnet_ids
}

# AKS Outputs
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "aks_kube_config_raw" {
  description = "Raw Kubernetes config for AKS"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "aks_get_credentials_command" {
  description = "Command to get AKS credentials"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${module.aks.cluster_name}"
}

# ACR Outputs
output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = module.acr.acr_id
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = module.acr.acr_name
}

output "acr_login_server" {
  description = "Login server for ACR"
  value       = module.acr.login_server
}

# Key Vault Outputs
output "keyvault_id" {
  description = "ID of the Key Vault"
  value       = module.keyvault.keyvault_id
}

output "keyvault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  description = "URI of the Key Vault"
  value       = module.keyvault.keyvault_uri
}

# Log Analytics Outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = module.log_analytics.workspace_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = module.log_analytics.workspace_name
}

# Application Insights Outputs
output "application_insights_id" {
  description = "ID of Application Insights"
  value       = module.application_insights.app_insights_id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = module.application_insights.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = module.application_insights.connection_string
  sensitive   = true
}

# PostgreSQL Outputs
output "postgresql_server_name" {
  description = "Name of the PostgreSQL server"
  value       = module.postgresql.server_name
}

output "postgresql_server_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = module.postgresql.server_fqdn
}

output "postgresql_administrator_login" {
  description = "Administrator login for PostgreSQL"
  value       = module.postgresql.administrator_login
  sensitive   = true
}

# Summary Output
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    resource_group  = azurerm_resource_group.main.name
    location        = azurerm_resource_group.main.location
    aks_cluster     = module.aks.cluster_name
    acr_name        = module.acr.acr_name
    keyvault_name   = module.keyvault.keyvault_name
    postgresql_fqdn = module.postgresql.server_fqdn
  }
}
