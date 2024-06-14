// Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                      = module.llmapp_naming.key_vault.name_unique
  resource_group_name       = var.resource_group
  location                  = var.location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  purge_protection_enabled  = true
  enable_rbac_authorization = true
}

// RBAC for Key Vault
resource "azurerm_role_assignment" "self" {
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.main.id
}

// Key for storage account
resource "azurerm_key_vault_key" "storage" {
  name         = "storage"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["unwrapKey", "wrapKey"]

  depends_on = [azurerm_role_assignment.self]
}

resource "azurerm_role_assignment" "storage" {
  principal_id         = azurerm_user_assigned_identity.storage.principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  scope                = "${azurerm_key_vault.main.id}/keys/${azurerm_key_vault_key.storage.name}"
}


// Key for AI Search
resource "azurerm_key_vault_key" "search" {
  name         = "search"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["unwrapKey", "wrapKey"]

  depends_on = [azurerm_role_assignment.self]
}

resource "azurerm_role_assignment" "search" {
  principal_id         = azurerm_search_service.main.identity.0.principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  scope                = "${azurerm_key_vault.main.id}/keys/${azurerm_key_vault_key.search.name}"
}

