resource "azurerm_network_interface" "nic" {
  name                = module.jump_naming.network_interface.name
  resource_group_name = var.resource_group
  location            = var.location

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = module.jump_naming.virtual_machine.name
  resource_group_name   = var.resource_group
  location              = var.location
  size                  = "Standard_B4as_v2"
  admin_username        = "adminuser"
  admin_password        = "Azure12345678"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-23h2-ent"
    version   = "latest"
  }
}
