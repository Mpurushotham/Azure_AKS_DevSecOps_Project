variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-ecommerce-prod"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
