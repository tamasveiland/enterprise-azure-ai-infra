module "llmapp_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llmapp"]
}

module "llmapp_storage_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llmapp", "storage"]
}

module "llmapp_search_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llmapp", "search"]
}