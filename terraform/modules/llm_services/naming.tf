module "llm_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llm"]
}