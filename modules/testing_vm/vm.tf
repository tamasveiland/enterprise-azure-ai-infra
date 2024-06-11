resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group
  location                        = var.location
  size                            = var.vm_size
  zone                            = var.zone
  network_interface_ids           = [azurerm_network_interface.main.id]
  admin_username                  = "adminuser"
  admin_password                  = var.password
  disable_password_authentication = false

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"

    diff_disk_settings {
      option    = "Local"
      placement = "ResourceDisk"
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  user_data = base64encode(file("${path.module}/install.sh"))
}
