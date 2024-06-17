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

module "llmapp_naming_deploy" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llmapp", "deploy"]
}