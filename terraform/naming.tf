module "hub_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "hub"]
}
