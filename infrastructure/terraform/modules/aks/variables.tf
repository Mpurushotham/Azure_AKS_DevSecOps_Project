# FILE: infrastructure/terraform/modules/aks/variables.tf
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "default_node_pool" {
  type = object({
    name                = string
    node_count          = number
    vm_size             = string
    vnet_subnet_id      = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    os_disk_size_gb     = number
    type                = string
  })
}

variable "network_profile" {
  type = object({
    network_plugin    = string
    network_policy    = string
    load_balancer_sku = string
    service_cidr      = string
    dns_service_ip    = string
  })
}

variable "azure_active_directory_role_based_access_control" {
  type = object({
    managed            = bool
    azure_rbac_enabled = bool
  })
}

variable "oms_agent" {
  type = object({
    log_analytics_workspace_id = string
  })
}

variable "acr_id" {
  type = string
}

variable "tags" {
  type = map(string)
}