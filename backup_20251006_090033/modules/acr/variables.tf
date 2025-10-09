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
