resource "azurerm_resource_group" "hub" {
  name     = module.hub_naming.resource_group.name
  location = var.location
}

resource "azurerm_resource_group" "shared" {
  name     = module.shared_naming.resource_group.name
  location = var.location
}
