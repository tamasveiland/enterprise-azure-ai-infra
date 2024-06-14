output "llmapp_fqdn" {
  value = azurerm_linux_web_app.main.default_hostname
}

output "llmapp_scm_fqdn" {
  value = "${azurerm_linux_web_app.main.name}.scm.azurewebsites.net"
}

output "search_principal_id" {
  value = azurerm_search_service.main.identity.0.principal_id
}

output "webapp_principal_id" {
  value = azurerm_linux_web_app.main.identity.0.principal_id
}
