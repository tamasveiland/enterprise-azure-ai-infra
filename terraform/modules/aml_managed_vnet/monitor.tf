resource "azurerm_application_insights" "main" {
  name                = module.aml_naming.application_insights.name_unique
  resource_group_name = var.resource_group
  location            = var.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = module.aml_naming.log_analytics_workspace.name_unique
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "PerGB2018"
}
