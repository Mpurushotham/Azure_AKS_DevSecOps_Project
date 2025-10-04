resource "azurerm_resource_group" "name" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
  
}
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  
  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    min_count           = var.default_node_pool.min_count
    max_count           = var.default_node_pool.max_count
    os_disk_size_gb     = var.default_node_pool.os_disk_size_gb
    type                = var.default_node_pool.type
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin    = var.network_profile.network_plugin
    network_policy    = var.network_profile.network_policy
    load_balancer_sku = var.network_profile.load_balancer_sku
    service_cidr      = var.network_profile.service_cidr
    dns_service_ip    = var.network_profile.dns_service_ip
  }
  
  azure_active_directory_role_based_access_control {
    managed            = var.azure_active_directory_role_based_access_control.managed
    azure_rbac_enabled = var.azure_active_directory_role_based_access_control.azure_rbac_enabled
  }
  
  oms_agent {
    log_analytics_workspace_id = var.oms_agent.log_analytics_workspace_id
  }
  
  tags = var.tags
  
  lifecycle {
    ignore_changes = [
      kubernetes_version
    ]
  }
}

resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
