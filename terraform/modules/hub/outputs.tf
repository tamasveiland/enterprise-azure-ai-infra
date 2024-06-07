output "hub_vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "fw_ip" {
  value = azurerm_firewall.main.ip_configuration[0].private_ip_address
}

output "firewall_policy_id" {
  value = azurerm_firewall_policy.main.id
}
