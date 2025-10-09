variable "resource_group_name" {
  type    = string
  default = "rg-ecommerce-prod"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "project_name" {
  type    = string
  default = "ecommerce"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "aks_subnet_address_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = "ecommerce"
  }
}
