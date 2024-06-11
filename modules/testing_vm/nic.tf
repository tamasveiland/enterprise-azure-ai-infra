resource "azurerm_network_interface" "main" {
  name                          = "${var.vm_name}-nic"
  resource_group_name           = var.resource_group
  location                      = var.location
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
