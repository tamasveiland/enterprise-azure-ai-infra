// Create hub
module "hub" {
  source         = "./modules/hub"
  prefix         = var.prefix
  resource_group = azurerm_resource_group.hub.name
  location       = var.location
  vnet_range     = "10.0.0.0/24"
}

// Create shared services
module "shared_services" {
  source         = "./modules/shared_services"
  prefix         = var.prefix
  resource_group = azurerm_resource_group.shared.name
  location       = var.location
  vnet_range     = "10.0.1.0/24"
  hub_vnet_id    = module.hub.hub_vnet_id
  fw_ip          = module.hub.fw_ip
}

// Create LLM solution
module "llm_services" {
  source                               = "./modules/llm_services"
  prefix                               = var.prefix
  resource_group                       = azurerm_resource_group.llm.name
  location                             = var.location
  vnet_range                           = "10.0.2.0/24"
  hub_vnet_id                          = module.hub.hub_vnet_id
  fw_ip                                = module.hub.fw_ip
  dns_ip                               = module.shared_services.dns_ip
  private_dns_zone_resource_group_name = azurerm_resource_group.shared.name

  depends_on = [ module.shared_services ]
}

module "llm_app" {
  source                               = "./modules/llm_app"
  prefix                               = var.prefix
  resource_group                       = azurerm_resource_group.llmapp.name
  location                             = var.location
  vnet_range                           = "10.0.3.0/24"
  hub_vnet_id                          = module.hub.hub_vnet_id
  fw_ip                                = module.hub.fw_ip
  dns_ip                               = module.shared_services.dns_ip
  private_dns_zone_resource_group_name = azurerm_resource_group.shared.name

  depends_on = [ module.shared_services ]
}
