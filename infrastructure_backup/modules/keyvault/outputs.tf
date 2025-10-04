
# FILE: infrastructure/terraform/modules/keyvault/outputs.tf
output "keyvault_id" {
  value = azurerm_key_vault.main.id
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "keyvault_uri" {
  value = azurerm_key_vault.main.vault_uri
}
# Output Definitions
output "keyvault_id" {
  description = "ID of the Azure Key Vault"
  value       = azurerm_key_vault.main.id
}

output "keyvault_name" {
  description = "Name of the Azure Key Vault"
  value       = azurerm_key_vault.main.name
}

output "keyvault_uri" {
  description = "URI of the Azure Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}
# FILE: infrastructure/terraform/modules/keyvault/outputs.tf    --- IGNORE ---
