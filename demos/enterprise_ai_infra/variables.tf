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

variable "vnet_range" {
  type        = string
  default     = "10.99.0.0/16"
  description = <<EOF
CIDR range for the virtual network.
EOF
}

variable "latency_vm_size" {
  type        = string
  default     = "Standard_D2ads_v5"
  description = <<EOF
Size of the VMs to create.
EOF
}

variable "enable_latency_demo" {
  type        = bool
  default     = true
  description = <<EOF
Enable the latency demo nad deploy couple of VMs in different zones and proximity placement groups.
EOF
}

variable "gpu_vm_size" {
  type        = string
  default     = "Standard_NC4as_T4_v3"
  description = <<EOF
Size of the GPU VMs to create.
EOF
}

variable "enable_gpu_demo" {
  type        = bool
  default     = true
  description = <<EOF
Enable the GPU demo and deploy a VM with a GPU.
EOF
}