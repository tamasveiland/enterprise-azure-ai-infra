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

variable "subnet_id" {
  type        = string
  description = <<EOF
ID of the subnet where the VMs will be placed.
EOF
}

variable "vm_size" {
  type = string
  default = "Standard_D2s_v3"
  description = <<EOF
Size of the VMs to create.
EOF
}

variable "zone" {
  type        = string
  description = <<EOF
Availability zone for the VMs.
EOF
}

variable "enable_accelerated_networking" {
  type = bool
  description = <<EOF
Enable accelerated networking on the VMs.
EOF
}

variable "vm_name" {
  type = string
  description = <<EOF
Name of the VM.
EOF
}

variable "password" {
  type = string
  default = "Azure12345678"
}