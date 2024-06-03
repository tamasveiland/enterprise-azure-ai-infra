// Create hub
module "hub" {
  source         = "./modules/hub"
  prefix         = var.prefix
  resource_group = azurerm_resource_group.hub.name
  location       = var.location
  vnet_range     = "10.0.0.0/24"
}
