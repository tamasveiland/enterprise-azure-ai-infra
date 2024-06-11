resource "azurerm_linux_virtual_machine" "vm1" {
  name                            = "${var.vm_name_prefix}-vm1"
  resource_group_name             = var.resource_group
  location                        = var.location
  size                            = var.vm_size
  zone                            = var.zone
  network_interface_ids           = [azurerm_network_interface.vm1.id]
  admin_username                  = "adminuser"
  admin_password                  = var.password
  disable_password_authentication = false
  proximity_placement_group_id    = azurerm_proximity_placement_group.main.id

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

resource "azurerm_linux_virtual_machine" "vm2" {
  name                            = "${var.vm_name_prefix}-vm2"
  resource_group_name             = var.resource_group
  location                        = var.location
  size                            = var.vm_size
  zone                            = var.zone
  network_interface_ids           = [azurerm_network_interface.vm2.id]
  admin_username                  = "adminuser"
  admin_password                  = var.password
  disable_password_authentication = false
  proximity_placement_group_id    = azurerm_proximity_placement_group.main.id

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
