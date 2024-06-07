output "openai_fqdn" {
  value = replace(replace(azurerm_cognitive_account.openai.endpoint, "https://", ""), "/", "")
}

output "azure_openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

output "azure_openai_resource" {
  value = azurerm_cognitive_account.openai.name
}

output "azure_openai_key" {
  value     = azurerm_cognitive_account.openai.primary_access_key
  sensitive = true
}

output "azure_openai_model" {
  value = azurerm_cognitive_deployment.gpt35.name
}

