resource "azurerm_resource_group" "infra" {
  name     = module.infra_naming.resource_group.name
  location = var.location
}
