// Azure AI Search
resource "azurerm_search_service" "main" {
  name                          = module.llmapp_naming.search_service.name_unique
  resource_group_name           = var.resource_group
  location                      = var.location
  sku                           = "standard"
  local_authentication_enabled  = false
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

// Private endpoint for Azure AI Search
data "azurerm_private_dns_zone" "search_service" {
  name                = "privatelink.search.windows.net"
  resource_group_name = var.private_dns_zone_resource_group_name
}

resource "azurerm_private_endpoint" "search_service" {
  name                = "${module.llmapp_naming.search_service.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.services.id

  private_service_connection {
    name                           = "${module.llmapp_naming.search_service.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_search_service.main.id
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.search_service.id]
  }
}

// Private Link connection to blob storage
resource "azurerm_search_shared_private_link_service" "blob" {
  name               = "${azurerm_storage_account.main.name}-spl"
  search_service_id  = azurerm_search_service.main.id
  subresource_name   = "blob"
  target_resource_id = azurerm_storage_account.main.id
  request_message    = "search"
}

# // Private Link connection to OpenAI
# resource "azurerm_search_shared_private_link_service" "openai" {
#   name               = "openai-spl"
#   search_service_id  = azurerm_search_service.main.id
#   subresource_name   = "blob"
#   target_resource_id = var.azure_openai_id
#   request_message    = "search"
# }

// Give access to OpenAI Service
resource "azurerm_role_assignment" "openai_search_service_contributor" {
  scope                = azurerm_search_service.main.id
  role_definition_name = "Search Service Contributor"
  principal_id         = var.azure_openai_principal_id
}

resource "azurerm_role_assignment" "openai_search_data_reader" {
  scope                = azurerm_search_service.main.id
  role_definition_name = "Search Index Data Reader"
  principal_id         = var.azure_openai_principal_id
}

// Give access to WebApp
resource "azurerm_role_assignment" "webapp_search_service_contributor" {
  scope                = azurerm_search_service.main.id
  role_definition_name = "Search Index Data Reader"
  principal_id         = azurerm_linux_web_app.main.identity[0].principal_id
}
