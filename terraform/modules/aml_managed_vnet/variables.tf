variable "prefix" {
  type        = string
  default     = "eai"
  description = <<EOF
Prefix for Azure resources. 

For example, a prefix of "demo" will result in resources named like "demo-hub-rg".
EOF
}

variable "location" {
  type        = string
  default     = "swedencentral"
  description = <<EOF
Location for all resources.

Example: "swedencentral"
EOF
}

variable "resource_group" {
  type        = string
  default     = "hub"
  description = <<EOF
Name of the resource group.
EOF
}

variable "vnet_range" {
  type        = string
  description = <<EOF
CIDR range for the virtual network.
EOF
}

variable "hub_vnet_id" {
  type        = string
  description = <<EOF
ID of the hub virtual network.
EOF
}

variable "fw_ip" {
  type        = string
  description = <<EOF
IP of Azure Firewall in hub subscription to be used as next hop for User Defined Routes
EOF
}

variable "dns_ip" {
  type        = string
  description = <<EOF
IP of the DNS server to be used for DNS resolution
EOF
}

variable "private_dns_zone_resource_group_name" {
  type        = string
  description = <<EOF
Name of the resource group where the private DNS zone is located.
EOF
}


# variable "azure_openai_resource" {
#   type        = string
#   description = "The name of the Azure OpenAI resource."
# }

# variable "azure_openai_model" {
#   type        = string
#   description = "The model to be used in the Azure OpenAI resource."
# }

# variable "azure_openai_key" {
#   type        = string
#   description = "The key for the Azure OpenAI resource."
# }

# variable "azure_openai_endpoint" {
#   type        = string
#   description = "The endpoint for the Azure OpenAI resource."
# }