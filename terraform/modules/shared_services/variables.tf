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
