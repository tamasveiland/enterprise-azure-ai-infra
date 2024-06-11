output "llmapp_fqdn" {
  value = azurerm_linux_web_app.main.default_hostname
}

output "llmapp_scm_fqdn" {
  value = "${azurerm_linux_web_app.main.name}.scm.azurewebsites.net"
}
