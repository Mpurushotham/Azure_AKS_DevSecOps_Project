# =============================================================================
# MODULE: networking
# FILE: infrastructure/terraform/modules/networking/main.tf
# =============================================================================

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  
  tags = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
  
  # Delegate subnet for database if needed
  dynamic "delegation" {
    for_each = each.key == "database" ? [1] : []
    content {
      name = "fs"
      service_delegation {
        name = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
        ]
      }
    }
  }
}

resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.subnets["aks"].id
  network_security_group_id = azurerm_network_security_group.aks.id
}
