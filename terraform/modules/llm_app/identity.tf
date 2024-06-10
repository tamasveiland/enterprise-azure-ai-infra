resource "azurerm_user_assigned_identity" "storage" {
  name                = module.llmapp_storage_naming.user_assigned_identity.name
  resource_group_name = var.resource_group
  location            = var.location
}

resource "azurerm_user_assigned_identity" "search" {
  name                = module.llmapp_search_naming.user_assigned_identity.name
  resource_group_name = var.resource_group
  location            = var.location
}