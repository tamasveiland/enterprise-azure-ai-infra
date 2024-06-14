// Create hub
module "hub" {
  source         = "../../modules/hub"
  prefix         = var.prefix
  resource_group = azurerm_resource_group.hub.name
  location       = var.location
  vnet_range     = "10.0.0.0/24"
}

// Firewall rules
module "firewall_rules" {
  source             = "../../modules/firewall_rules"
  firewall_policy_id = module.hub.firewall_policy_id
  openai_fqdn        = module.llm_services.openai_fqdn
  dns_ip             = module.shared_services.dns_ip
  llmapp_fqdn        = module.llm_app.llmapp_fqdn
  llmapp_scm_fqdn    = module.llm_app.llmapp_scm_fqdn
}

// Create shared services
module "shared_services" {
  source         = "../../modules/shared_services"
  prefix         = var.prefix
  resource_group = azurerm_resource_group.shared.name
  location       = var.location
  vnet_range     = "10.0.1.0/24"
  hub_vnet_id    = module.hub.hub_vnet_id
  fw_ip          = module.hub.fw_ip
}

// Create LLM solution
module "llm_services" {
  source                               = "../../modules/llm_services"
  prefix                               = var.prefix
  resource_group                       = azurerm_resource_group.llm.name
  location                             = var.location
  vnet_range                           = "10.0.2.0/24"
  hub_vnet_id                          = module.hub.hub_vnet_id
  fw_ip                                = module.hub.fw_ip
  dns_ip                               = module.shared_services.dns_ip
  private_dns_zone_resource_group_name = azurerm_resource_group.shared.name
  search_principal_id                  = module.llm_app.search_principal_id
  webapp_principal_id                  = module.llm_app.webapp_principal_id

  depends_on = [module.shared_services]
}

module "llm_app" {
  source                               = "../../modules/llm_app"
  prefix                               = var.prefix
  resource_group                       = azurerm_resource_group.llmapp.name
  location                             = var.location
  vnet_range                           = "10.0.3.0/24"
  hub_vnet_id                          = module.hub.hub_vnet_id
  fw_ip                                = module.hub.fw_ip
  dns_ip                               = module.shared_services.dns_ip
  private_dns_zone_resource_group_name = azurerm_resource_group.shared.name
  azure_openai_endpoint                = module.llm_services.azure_openai_endpoint
  azure_openai_key                     = module.llm_services.azure_openai_key
  azure_openai_model                   = module.llm_services.azure_openai_model
  azure_openai_resource                = module.llm_services.azure_openai_resource
  azure_openai_principal_id            = module.llm_services.azure_openai_principal_id

  depends_on = [module.shared_services]
}

// Azure Machine Learning with Managed VNET
module "aml_managed_vnet" {
  source                               = "../../modules/aml_managed_vnet"
  prefix                               = var.prefix
  resource_group                       = azurerm_resource_group.amlmanagedvnet.name
  location                             = var.location
  vnet_range                           = "10.0.4.0/24"
  hub_vnet_id                          = module.hub.hub_vnet_id
  fw_ip                                = module.hub.fw_ip
  dns_ip                               = module.shared_services.dns_ip
  private_dns_zone_resource_group_name = azurerm_resource_group.shared.name
}
