// Azure AI Search
resource "azurerm_search_service" "main" {
  name                          = module.llmapp_naming.search_service.name
  resource_group_name           = var.resource_group
  location                      = var.location
  sku                           = "standard"
  local_authentication_enabled  = false
  public_network_access_enabled = false
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
  request_message    = "ai-search-connection-to-blob-storage"
}