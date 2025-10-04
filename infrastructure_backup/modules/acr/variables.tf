# FILE: infrastructure/terraform/modules/acr/variables.tf
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Premium"
}

variable "admin_enabled" {
  type    = bool
  default = false
}

variable "network_rule_set" {
  type = object({
    default_action             = string
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "tags" {
  type = map(string)
}
# Output Definitions
output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.main.id
}
output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.main.name
}
# FILE: infrastructure/terraform/modules/acr/main.tf