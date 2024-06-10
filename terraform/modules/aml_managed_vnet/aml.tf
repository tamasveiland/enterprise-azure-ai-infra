resource "azurerm_machine_learning_workspace" "main" {
  name                           = module.aml_naming.machine_learning_workspace.name
  resource_group_name            = var.resource_group
  location                       = var.location
  application_insights_id        = azurerm_application_insights.main.id
  key_vault_id                   = azurerm_key_vault.main.id
  storage_account_id             = azurerm_storage_account.main.id
  high_business_impact           = false
  primary_user_assigned_identity = azurerm_user_assigned_identity.aml.id

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aml.id,
    ]
  }

  encryption {
    user_assigned_identity_id = azurerm_user_assigned_identity.aml.id
    key_vault_id              = azurerm_key_vault.main.id
    key_id                    = azurerm_key_vault_key.aml.id
  }

  managed_network {
    isolation_mode = "AllowOnlyApprovedOutbound"
  }

  depends_on = [
    azurerm_role_assignment.aml_storage,
    azurerm_role_assignment.aml_kv_read,
  ]
}
