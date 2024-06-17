resource "azurerm_service_plan" "main" {
  name                = module.llmapp_naming.app_service_plan.name
  resource_group_name = var.resource_group
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "random_string" "webapp" {
  length  = 4
  special = false
  upper   = false
  lower   = true
  numeric = false
}

resource "azurerm_linux_web_app" "main" {
  name                      = module.llmapp_naming.app_service.name_unique
  resource_group_name       = var.resource_group
  location                  = var.location
  service_plan_id           = azurerm_service_plan.main.id
  virtual_network_subnet_id = azurerm_subnet.appservice.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    vnet_route_all_enabled = true
    always_on              = false

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "AZURE_OPENAI_RESOURCE"          = var.azure_openai_resource
    "AZURE_OPENAI_MODEL"             = var.azure_openai_model
    # "AZURE_OPENAI_KEY"               = var.azure_openai_key
    "AZURE_OPENAI_ENDPOINT"          = var.azure_openai_endpoint
    "AZURE_OPENAI_SYSTEM_MESSAGE"    = "You are funny AI assistant that talks about vegetables that became conscious. You will be presented with context to base your answers on, follow it."
    "UI_TITLE"                       = "CE Tech Community"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "UI_LOGO"                        = "https://raw.githubusercontent.com/tkubica12/enterprise-azure-ai-infra/main/images/csu-logo.png"
    "AZURE_SEARCH_SERVICE"           = azurerm_search_service.main.name
    "AZURE_SEARCH_INDEX"             = "vegetables"
    "DATASOURCE_TYPE"                = "AzureCognitiveSearch"
    "AZURE_SEARCH_QUERY_TYPE"        = "vectorSimpleHybrid"
    "AZURE_OPENAI_EMBEDDING_NAME"    = "text-embedding-ada-002"
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
