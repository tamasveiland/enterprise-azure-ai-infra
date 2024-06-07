resource "azurerm_storage_account" "main" {
  name                     = module.llmapp_naming.storage_account.name_unique
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
