resource "azurerm_virtual_network" "main" {
  name                = module.hub_naming.virtual_network.name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = [var.vnet_range]
}

resource "azurerm_subnet" "azure_fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 2, 0)]
}

resource "azurerm_subnet" "azure_fw_mgmt" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 2, 1)]
}
