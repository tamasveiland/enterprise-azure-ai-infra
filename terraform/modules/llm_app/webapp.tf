resource "azurerm_service_plan" "main" {
  name                = module.llmapp_naming.app_service_plan.name
  resource_group_name = var.resource_group
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "random_string" "webapp" {
  length  = 4
  special = false
  upper   = false
  lower   = true
  numeric = false
}

resource "azurerm_linux_web_app" "main" {
  name                      = "llmapp-${random_string.webapp.result}"
  resource_group_name       = var.resource_group
  location                  = var.location
  service_plan_id           = azurerm_service_plan.main.id
  virtual_network_subnet_id = azurerm_subnet.appservice.id

  site_config {
    vnet_route_all_enabled = true

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "AZURE_OPENAI_RESOURCE"          = var.azure_openai_resource
    "AZURE_OPENAI_MODEL"             = var.azure_openai_model
    "AZURE_OPENAI_KEY"               = var.azure_openai_key
    "AZURE_OPENAI_ENDPOINT"          = var.azure_openai_endpoint
    "AZURE_OPENAI_SYSTEM_MESSAGE"    = "You are helpful AI assistent specializing in answering questions about Azure networking concepts such as Private Endpoints, VNETs, Azure Firewall, Routing and network related services such as NSG, Application Gateway and others."
    "UI_TITLE"                       = "CE Tech Community"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }
}

resource "azurerm_app_service_source_control" "main" {
  app_id                 = azurerm_linux_web_app.main.id
  repo_url               = "https://github.com/microsoft/sample-app-aoai-chatGPT.git"
  branch                 = "main"
  use_manual_integration = true
}

// Private Endpoint (frontend of app)
data "azurerm_private_dns_zone" "webapp" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.private_dns_zone_resource_group_name
}

resource "azurerm_private_endpoint" "main" {
  name                = "${azurerm_linux_web_app.main.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.appservicefrontend.id

  private_dns_zone_group {
    name                 = "webapp"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.webapp.id]
  }

  private_service_connection {
    name                           = "privateServiceConnection1"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.main.id
    subresource_names              = ["sites"]
  }
}
