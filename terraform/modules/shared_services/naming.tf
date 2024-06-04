module "shared_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "shared"]
}

module "bastion_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "bastion"]
}

module "jump_naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.prefix, "jump"]
}
