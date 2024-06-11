module "vm-na-z1-vm1" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = false
  zone                          = "1"
  vm_name                       = "vm-na-z1-vm1"
  vm_size                       = var.latency_vm_size
}

module "vm-na-z2-vm1" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = false
  zone                          = "2"
  vm_name                       = "vm-na-z2-vm1"
  vm_size                       = var.latency_vm_size
}

module "vm-na-z3-vm1" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = false
  zone                          = "3"
  vm_name                       = "vm-na-z3-vm1"
  vm_size                       = var.latency_vm_size
}

module "vm-a-z1-vm1" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "1"
  vm_name                       = "vm-a-z1-vm1"
  vm_size                       = var.latency_vm_size
}

module "vm-a-z1-vm2" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "1"
  vm_name                       = "vm-a-z1-vm2"
  vm_size                       = var.latency_vm_size
}


module "vm-a-z2-vm1" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "2"
  vm_name                       = "vm-a-z2-vm1"
  vm_size                       = var.latency_vm_size
}

module "vm-a-z2-vm2" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "2"
  vm_name                       = "vm-a-z2-vm2"
  vm_size                       = var.latency_vm_size
}

module "vm-a-z3-vm1" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "3"
  vm_name                       = "vm-a-z3-vm1"
  vm_size                       = var.latency_vm_size
}

module "vm-a-z3-vm3" {
  source                        = "../../modules/testing_vm"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "3"
  vm_name                       = "vm-a-z3-vm2"
  vm_size                       = var.latency_vm_size
}

module "vm-ppg-z1" {
  source                        = "../../modules/ppg_vms"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "1"
  vm_name_prefix                = "vm-ppg-z1"
  vm_size                       = var.latency_vm_size
}


module "vm-ppg-z2" {
  source                        = "../../modules/ppg_vms"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "2"
  vm_name_prefix                = "vm-ppg-z2"
  vm_size                       = var.latency_vm_size
}


module "vm-ppg-z3" {
  source                        = "../../modules/ppg_vms"
  count                         = var.enable_latency_demo ? 1 : 0
  location                      = var.location
  resource_group                = azurerm_resource_group.infra.name
  subnet_id                     = azurerm_subnet.default.id
  enable_accelerated_networking = true
  zone                          = "3"
  vm_name_prefix                = "vm-ppg-z3"
  vm_size                       = var.latency_vm_size
}


