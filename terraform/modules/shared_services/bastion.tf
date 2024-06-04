resource "azurerm_public_ip" "bastion" {
  name                = module.bastion_naming.public_ip.name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = module.bastion_naming.bastion_host.name
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
