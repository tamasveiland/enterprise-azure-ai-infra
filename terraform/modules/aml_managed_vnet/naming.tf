module "aml_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "amlmanagedvnet"]
}

module "aml_storage_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "amlmanagedvnet", "storage"]
}
