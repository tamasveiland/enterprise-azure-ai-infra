module "infra_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "infra"]
}