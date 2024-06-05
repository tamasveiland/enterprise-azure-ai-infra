module "hub_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "hub"]
}

module "shared_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "shared"]
}

module "llm_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llm"]
}

module "llmapp_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llmapp"]
}