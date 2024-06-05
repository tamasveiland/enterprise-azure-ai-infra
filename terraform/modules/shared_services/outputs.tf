output "dns_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.main.ip_configurations[0].private_ip_address
  description = <<EOF
Private IP address of the DNS resolver to be used for DNS resolution from other subscriptions or as target from on-premises.
EOF
}
