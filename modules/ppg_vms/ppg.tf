resource "azurerm_proximity_placement_group" "main" {
  name                = "${var.vm_name_prefix}-ppg"
  resource_group_name             = var.resource_group
  location                        = var.location

  tags = {
    environment = "Production"
  }
}