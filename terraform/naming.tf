module "hub_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "hub"]
}

module "shared_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "shared"]
}
