resource "azurerm_public_ip" "fw" {
  name                = module.fw_naming.public_ip.name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "fw_management" {
  name                = module.fw_mgmt_naming.public_ip.name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_firewall_policy" "main" {
  name                = module.fw_naming.firewall_policy.name
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_firewall" "main" {
  name                = module.fw_naming.firewall.name
  resource_group_name = var.resource_group
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  firewall_policy_id  = azurerm_firewall_policy.main.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azure_fw.id
    public_ip_address_id = azurerm_public_ip.fw.id
  }

  management_ip_configuration {
    name                 = "management"
    subnet_id            = azurerm_subnet.azure_fw_mgmt.id
    public_ip_address_id = azurerm_public_ip.fw_management.id
  }
}
