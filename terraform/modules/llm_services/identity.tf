resource "azurerm_user_assigned_identity" "main" {
  name                = module.llm_naming.user_assigned_identity.name
  resource_group_name = var.resource_group
  location            = var.location
}