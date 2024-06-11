resource "azurerm_resource_group" "hub" {
  name     = module.hub_naming.resource_group.name
  location = var.location
}

resource "azurerm_resource_group" "shared" {
  name     = module.shared_naming.resource_group.name
  location = var.location
}

resource "azurerm_resource_group" "llm" {
  name     = module.llm_naming.resource_group.name
  location = var.location
}

resource "azurerm_resource_group" "llmapp" {
  name     = module.llmapp_naming.resource_group.name
  location = var.location
}

resource "azurerm_resource_group" "amlmanagedvnet" {
  name     = module.aml_managed_vnet_naming.resource_group.name
  location = var.location
}

