resource "azurerm_cognitive_account" "openai" {
  name                  = module.llm_naming.cognitive_account.name
  resource_group_name   = var.resource_group
  location              = var.location
  kind                  = "OpenAI"
  sku_name              = "S0"
  custom_subdomain_name = module.llm_naming.cognitive_account.name

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }
}

resource "azurerm_key_vault_key" "openai" {
  name         = "openai-key"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

resource "azurerm_cognitive_account_customer_managed_key" "openai" {
  cognitive_account_id = azurerm_cognitive_account.openai.id
  key_vault_key_id     = azurerm_key_vault_key.openai.id
  identity_client_id   = azurerm_user_assigned_identity.main.client_id
}

resource "azurerm_private_endpoint" "openai" {
  name                = "${module.llm_naming.cognitive_account.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.services.id

  private_service_connection {
    name                           = "${module.llm_naming.cognitive_account.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names              = ["account"]
  }
}
