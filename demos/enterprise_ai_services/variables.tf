variable "prefix" {
  type        = string
  default     = "cetc"
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
