locals {
  zones = [
    "privatelink.openai.azure.com",
    "privatelink.search.windows.net",
    "privatelink.azurewebsites.net",
    "privatelink.blob.core.windows.net",
  ]
}

// Private DNS zones
resource "azurerm_private_dns_zone" "main" {
  for_each            = toset(local.zones)
  name                = each.value
  resource_group_name = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  for_each              = toset(local.zones)
  name                  = "${replace(each.key, ".", "-")}-link"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.main[each.key].name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  for_each              = toset(local.zones)
  name                  = "${replace(each.key, ".", "-")}-hub-link"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.main[each.key].name
  virtual_network_id    = var.hub_vnet_id
}

// Private DNS resolver
resource "azurerm_private_dns_resolver" "main" {
  name                = "dnspr-${var.prefix}-shared"
  resource_group_name = var.resource_group
  location            = var.location
  virtual_network_id  = azurerm_virtual_network.main.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "main" {
  name                    = "in-${var.prefix}-shared"
  private_dns_resolver_id = azurerm_private_dns_resolver.main.id
  location                = var.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_in.id
  }
}


