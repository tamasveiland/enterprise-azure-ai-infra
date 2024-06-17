variable "prefix" {
  type        = string
  default     = "cetc"
  description = <<EOF
Prefix for Azure resources. 
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
