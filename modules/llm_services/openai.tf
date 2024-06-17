// Azure OpenAI Service
resource "azurerm_cognitive_account" "openai" {
  name                          = module.llm_naming.cognitive_account.name_unique
  resource_group_name           = var.resource_group
  location                      = var.location
  kind                          = "OpenAI"
  sku_name                      = "S0"
  custom_subdomain_name         = module.llm_naming.cognitive_account.name
  public_network_access_enabled = true

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  lifecycle {
    ignore_changes = [customer_managed_key, network_acls]
  }

  timeouts {
    create = "120m"
    update = "120m"
    delete = "120m"
  }
}

// Model deployment
resource "azurerm_cognitive_deployment" "gpt35" {
  name                 = "gpt35"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "1106"
  }

  scale {
    type     = "Standard"
    capacity = 60
  }
}

resource "azurerm_cognitive_deployment" "embeddings" {
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }

  scale {
    type     = "Standard"
    capacity = 100
  }
}

// Key Vault for cognitive service encryption
resource "azurerm_key_vault_key" "openai" {
  name         = "openai-key"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  # depends_on = [azurerm_role_assignment.self]
}

// Customer managed key for cognitive service
resource "azurerm_cognitive_account_customer_managed_key" "openai" {
  cognitive_account_id = azurerm_cognitive_account.openai.id
  key_vault_key_id     = azurerm_key_vault_key.openai.id
  identity_client_id   = azurerm_user_assigned_identity.main.client_id

  # depends_on = [azurerm_role_assignment.openai_kv]
}

// Private endpoint for cognitive service
data "azurerm_private_dns_zone" "openai" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = var.private_dns_zone_resource_group_name
}

resource "azurerm_private_endpoint" "openai" {
  name                = "${module.llm_naming.cognitive_account.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.services.id
  private_dns_zone_group {
    name                 = "openai"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.openai.id]
  }

  private_service_connection {
    name                           = "${module.llm_naming.cognitive_account.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names              = ["account"]
  }
}


// Give access to AI Search
resource "azurerm_role_assignment" "search_openai" {
  principal_id         = var.search_principal_id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  scope                = azurerm_cognitive_account.openai.id
}
// Give access to WebApp
resource "azurerm_role_assignment" "webapp_openai" {
  principal_id         = var.webapp_principal_id
  role_definition_name = "Cognitive Services OpenAI User"
  scope                = azurerm_cognitive_account.openai.id
}
