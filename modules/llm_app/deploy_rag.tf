// Identity used for deployment script
resource "azurerm_user_assigned_identity" "deploy" {
  name                = module.llmapp_naming_deploy.user_assigned_identity.name
  resource_group_name = var.resource_group
  location            = var.location
}

// Give access to blob, search service and openai
resource "azurerm_role_assignment" "deploy_storage" {
  principal_id         = azurerm_user_assigned_identity.deploy.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.main.id
}

resource "azurerm_role_assignment" "deploy_storage_contributor" {
  principal_id         = azurerm_user_assigned_identity.deploy.principal_id
  role_definition_name = "Contributor"
  scope                = azurerm_storage_account.main.id
}

resource "azurerm_role_assignment" "deploy_search" {
  principal_id         = azurerm_user_assigned_identity.deploy.principal_id
  role_definition_name = "Search Service Contributor"
  scope                = azurerm_search_service.main.id
}

resource "azurerm_role_assignment" "deploy_openai" {
  principal_id         = azurerm_user_assigned_identity.deploy.principal_id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  scope                = var.azure_openai_id
}

resource "azurerm_role_assignment" "deploy_webapp" {
  principal_id         = azurerm_user_assigned_identity.deploy.principal_id
  role_definition_name = "Contributor"
  scope                = azurerm_linux_web_app.main.id
}

// Logging workspace
resource "azurerm_log_analytics_workspace" "deploy" {
  name                = module.llmapp_naming_deploy.log_analytics_workspace.name_unique
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

// Container with script
resource "azurerm_container_group" "deploy" {
  name                = module.llmapp_naming_deploy.container_group.name
  resource_group_name = var.resource_group
  location            = var.location
  os_type             = "Linux"
  ip_address_type     = "Private"
  restart_policy      = "OnFailure"

  diagnostics {
    log_analytics {
      workspace_id  = azurerm_log_analytics_workspace.deploy.workspace_id
      workspace_key = azurerm_log_analytics_workspace.deploy.primary_shared_key
    }
  }

  subnet_ids = [
    azurerm_subnet.container_instances.id
  ]

  container {
    name   = "deploy"
    image  = "python:3.12"
    cpu    = "0.5"
    memory = "1.5"
    commands = [
      "/bin/bash", "-c",
      "echo $SCRIPT | base64 -d | bash; sleep 10000; echo ---------------------- Done ----------------------",
    ]

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      SCRIPT                        = base64encode(local.script)
      AZURE_SEARCH_SERVICE_ENDPOINT = "https://${azurerm_search_service.main.name}.search.windows.net"
      AZURE_OPENAI_ENDPOINT         = var.azure_openai_endpoint
      BLOB_RESOURCE_ID              = azurerm_storage_account.main.id
      AZURE_SUBSCRIPTION_ID         = data.azurerm_client_config.current.subscription_id
      AZURE_RESOURCE_GROUP          = var.resource_group
      AZURE_APP_NAME                = azurerm_linux_web_app.main.name
      AZURE_STORAGE_ACCOUNT_NAME    = azurerm_storage_account.main.name
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.deploy.id
    ]
  }

  depends_on = [
    azurerm_role_assignment.deploy_storage,
    azurerm_role_assignment.deploy_search,
    azurerm_role_assignment.deploy_openai
  ]
}



locals {
  requirements = file("${path.module}/src/requirements.txt")
  indexing     = file("${path.module}/src/indexing.py")

  script = <<-EOF
    echo -------- Creating files --------
    cat > requirements.txt <<-END
    ${local.requirements}
    END

    cat > indexing.py <<-END
    ${local.indexing}
    END

    echo -------- Installing Python dependencies --------
    pip install -r requirements.txt

    echo -------- Running Python --------
    python indexing.py
  EOF
}
