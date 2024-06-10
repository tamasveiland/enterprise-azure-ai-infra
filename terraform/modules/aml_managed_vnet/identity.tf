resource "azurerm_user_assigned_identity" "storage" {
  name                = module.aml_storage_naming.user_assigned_identity.name
  resource_group_name = var.resource_group
  location            = var.location
}

resource "azurerm_user_assigned_identity" "aml" {
  name                = module.aml_naming.user_assigned_identity.name
  resource_group_name = var.resource_group
  location            = var.location
}
