resource "azurerm_resource_group" "main" {
  name     = module.infra_naming.resource_group.name
  location = var.location
}