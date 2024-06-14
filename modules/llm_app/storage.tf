// Storage account
resource "azurerm_storage_account" "main" {
  name                     = module.llmapp_naming.storage_account.name_unique
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.storage.id]
  }

  customer_managed_key {
    key_vault_key_id          = azurerm_key_vault_key.storage.id
    user_assigned_identity_id = azurerm_user_assigned_identity.storage.id
  }

  depends_on = [azurerm_role_assignment.storage]
}

// Storage container
resource "azurerm_storage_container" "main" {
  name                  = "rag"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

// Upload data to storage account
resource "azurerm_storage_blob" "main" {
  for_each               = fileset("${path.module}/../../data", "**")
  name                   = each.key
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type                   = "Block"
  source                 = "${path.module}/../../data/${each.key}"
}

// Private endpoint for storage account
data "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.private_dns_zone_resource_group_name
}
resource "azurerm_private_endpoint" "storage" {
  name                = "${azurerm_storage_account.main.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.services.id

  private_service_connection {
    name                           = "${azurerm_storage_account.main.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.blob.id]
  }
}

// Give access to Azure AI Search
resource "azurerm_role_assignment" "search_service_storage_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_search_service.main.identity[0].principal_id
}

// Give access to Azure OpenAI
resource "azurerm_role_assignment" "openai_storage_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.azure_openai_principal_id
}

// Give access to self
resource "azurerm_role_assignment" "self_storage_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}