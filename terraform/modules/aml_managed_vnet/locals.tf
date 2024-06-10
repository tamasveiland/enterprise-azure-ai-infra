locals {
  split_hub_vnet_id = split("/", var.hub_vnet_id)
  hub_resource_group_index = index(local.split_hub_vnet_id, "resourceGroups")
  hub_resource_group_name = local.split_hub_vnet_id[local.hub_resource_group_index + 1]
  hub_virtual_network_index = index(local.split_hub_vnet_id, "virtualNetworks")
  hub_virtual_network_name = local.split_hub_vnet_id[local.hub_virtual_network_index + 1]
}