output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "aks_get_credentials" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "acr_admin_username" {
  value     = azurerm_container_registry.main.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_container_registry.main.admin_password
  sensitive = true
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "next_steps" {
  value = <<-EOT
  
  ✅ Infrastructure deployed successfully!
  
  Next steps:
  1. Get AKS credentials:
     az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}
  
  2. Verify cluster:
     kubectl get nodes
  
  3. Login to ACR:
     az acr login --name ${azurerm_container_registry.main.name}
  
  4. Deploy applications:
     cd ../../
     kubectl apply -f k8s/base/
  
  EOT
}
