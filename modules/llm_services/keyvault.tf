resource "azurerm_key_vault" "main" {
  name                      = module.llm_naming.key_vault.name_unique
  resource_group_name       = var.resource_group
  location                  = var.location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  purge_protection_enabled  = true
  enable_rbac_authorization = true
}

// Give access to self
resource "azurerm_role_assignment" "self" {
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.main.id
}

// Give access to OpenAI for encryption
resource "azurerm_role_assignment" "openai" {
  principal_id         = azurerm_cognitive_account.openai.identity[0].principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  scope                = azurerm_key_vault.main.id
}
