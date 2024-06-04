resource "azurerm_virtual_network" "main" {
  name                = module.shared_naming.virtual_network.name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = [var.vnet_range]
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 2, 0)]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 2, 1)]
}
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-shared"
  resource_group_name       = local.hub_resource_group_name
  virtual_network_name      = local.hub_virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.main.id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "shared-to-hub"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = var.hub_vnet_id
}
