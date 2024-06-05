module "llmapp_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "llmapp"]
}