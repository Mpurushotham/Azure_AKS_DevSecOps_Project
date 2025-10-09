resource "azurerm_key_vault" "main" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 90
  purge_protection_enabled   = false  # Changed to false for easier testing
  
  # Start with no network restrictions
  # dynamic "network_acls" {
  #   for_each = var.network_acls != null ? [var.network_acls] : []
  #   content {
  #     default_action             = network_acls.value.default_action
  #     bypass                     = network_acls.value.bypass
  #     virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
  #   }
  # }
  
  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "policies" {
  count = length(var.access_policies)
  
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.access_policies[count.index].tenant_id
  object_id    = var.access_policies[count.index].object_id
  
  key_permissions         = var.access_policies[count.index].key_permissions
  secret_permissions      = var.access_policies[count.index].secret_permissions
  certificate_permissions = var.access_policies[count.index].certificate_permissions
}
