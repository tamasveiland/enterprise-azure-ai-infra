// Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                      = module.aml_naming.key_vault.name_unique
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

// Key for AML
resource "azurerm_key_vault_key" "aml" {
  name         = "aml"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["unwrapKey", "wrapKey"]

  depends_on = [azurerm_role_assignment.self]
}

resource "azurerm_role_assignment" "aml" {
  principal_id         = azurerm_user_assigned_identity.aml.principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  scope                = "${azurerm_key_vault.main.id}/keys/${azurerm_key_vault_key.aml.name}"
}

resource "azurerm_role_assignment" "aml_kv_read" {
  principal_id         = azurerm_user_assigned_identity.aml.principal_id
  role_definition_name = "Key Vault Reader"
  scope                = azurerm_key_vault.main.id
}




