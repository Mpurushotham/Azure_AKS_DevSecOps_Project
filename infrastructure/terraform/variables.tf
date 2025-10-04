# =============================================================================
# FILE: infrastructure/terraform/variables.tf
# Variable Definitions
# =============================================================================

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-ecommerce-prod"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ecommerce"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

# Networking Variables
variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_address_prefix" {
  description = "Address prefix for AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "database_subnet_address_prefix" {
  description = "Address prefix for database subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "services_subnet_address_prefix" {
  description = "Address prefix for services subnet"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

# AKS Variables
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.3"
}

variable "system_node_count" {
  description = "Number of system nodes"
  type        = number
  default     = 3
}

variable "system_node_vm_size" {
  description = "VM size for system nodes"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "system_node_min_count" {
  description = "Minimum number of system nodes for autoscaling"
  type        = number
  default     = 3
}

variable "system_node_max_count" {
  description = "Maximum number of system nodes for autoscaling"
  type        = number
  default     = 10
}

variable "user_node_count" {
  description = "Number of user nodes"
  type        = number
  default     = 3
}

variable "user_node_vm_size" {
  description = "VM size for user nodes"
  type        = string
  default     = "Standard_D8s_v3"
}

variable "user_node_min_count" {
  description = "Minimum number of user nodes for autoscaling"
  type        = number
  default     = 3
}

variable "user_node_max_count" {
  description = "Maximum number of user nodes for autoscaling"
  type        = number
  default     = 20
}

# ACR Variables
variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Premium"
}

# Log Analytics Variables
variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 90
}

# PostgreSQL Variables
variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
  default     = "psqladmin"
  sensitive   = true
}

variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "postgres_sku_name" {
  description = "SKU name for PostgreSQL"
  type        = string
  default     = "GP_Standard_D4s_v3"
}

variable "postgres_storage_mb" {
  description = "Storage size in MB for PostgreSQL"
  type        = number
  default     = 32768
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "14"
}

variable "postgres_backup_retention_days" {
  description = "Backup retention days for PostgreSQL"
  type        = number
  default     = 35
}

variable "postgres_geo_redundant_backup" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = true
}

variable "postgres_ha_enabled" {
  description = "Enable high availability for PostgreSQL"
  type        = bool
  default     = true
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = "ecommerce"
  }
}