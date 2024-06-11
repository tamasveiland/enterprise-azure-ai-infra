module "vm-gpu" {
  source         = "../../modules/gpu_vm"
  count          = var.enable_gpu_demo ? 1 : 0
  location       = var.location
  resource_group = azurerm_resource_group.infra.name
  subnet_id      = azurerm_subnet.default.id
  vm_name        = "vm-gpu"
  vm_size        = var.gpu_vm_size
}
