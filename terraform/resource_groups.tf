resource "azurerm_resource_group" "hub" {
  name     = module.hub_naming.resource_group.name
  location = var.location
}
