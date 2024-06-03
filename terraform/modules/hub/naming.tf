module "hub_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "hub"]
}

module "fw_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "hub", "fw"]
}

module "fw_mgmt_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "hub", "fw", "mgmt"]
}
