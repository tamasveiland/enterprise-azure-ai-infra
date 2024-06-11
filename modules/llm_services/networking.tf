resource "azurerm_virtual_network" "main" {
  name                = module.llm_naming.virtual_network.name
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = [var.vnet_range]
  dns_servers         = [var.dns_ip]
}

// Subnets
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 2, 0)]
}

resource "azurerm_subnet" "services" {
  name                              = "services"
  resource_group_name               = var.resource_group
  virtual_network_name              = azurerm_virtual_network.main.name
  address_prefixes                  = [cidrsubnet(var.vnet_range, 2, 1)]
  private_endpoint_network_policies = "Enabled" // Without this return traffic goes directly and ignore UDR so firewall in hub would work only if doing L7 + without this NSGs would be ignored
}

// Peerings
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "hub-to-llm"
  resource_group_name          = local.hub_resource_group_name
  virtual_network_name         = local.hub_virtual_network_name
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "llm-to-hub"
  resource_group_name          = var.resource_group
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

// Route table and route

resource "azurerm_route_table" "main" {
  name                = module.llm_naming.route_table.name
  resource_group_name = var.resource_group
  location            = var.location
}

resource "azurerm_route" "all" {
  name                   = "all"
  route_table_name       = azurerm_route_table.main.name
  resource_group_name    = var.resource_group
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.fw_ip
}

// Add routes to subnets
resource "azurerm_subnet_route_table_association" "default" {
  subnet_id      = azurerm_subnet.default.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet_route_table_association" "services" {
  subnet_id      = azurerm_subnet.services.id
  route_table_id = azurerm_route_table.main.id
}
