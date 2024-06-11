resource "azurerm_virtual_network" "main" {
  name                = module.infra_naming.virtual_network.name
  resource_group_name = azurerm_resource_group.infra.name
  location            = var.location
  address_space       = [var.vnet_range]
}

// Subnets
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 2, 0)]
}
