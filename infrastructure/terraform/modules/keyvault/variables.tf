# FILE: infrastructure/terraform/modules/keyvault/variables.tf
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "premium"
}

variable "network_acls" {
  type = object({
    default_action             = string
    bypass                     = string
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "access_policies" {
  type = list(object({
    tenant_id               = string
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
  default = []
}

variable "tags" {
  type = map(string)
}
