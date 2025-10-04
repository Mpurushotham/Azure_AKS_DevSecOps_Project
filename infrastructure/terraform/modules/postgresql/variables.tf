# FILE: infrastructure/terraform/modules/postgresql/variables.tf
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "server_name" {
  type = string
}

variable "administrator_login" {
  type      = string
  sensitive = true
}

variable "administrator_password" {
  type      = string
  sensitive = true
}

variable "sku_name" {
  type = string
}

variable "storage_mb" {
  type = number
}

variable "version" {
  type = string
}

variable "backup_retention_days" {
  type = number
}

variable "geo_redundant_backup_enabled" {
  type = bool
}

variable "high_availability" {
  type = object({
    mode = string
  })
}

variable "delegated_subnet_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
# FILE: infrastructure/terraform/modules/postgresql/variables.tf    --- IGNORE ---
