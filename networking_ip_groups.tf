

module "ip_groups" {
  source   = "./modules/networking/ip_group"
  for_each = local.networking.ip_groups

  global_settings = local.global_settings
  client_config   = local.client_config
  name            = each.value.name
  resource_group  = local.resource_groups[each.value.resource_group_key]
  tags            = try(each.value.tags, null)
  vnet            = lookup(each.value, "cidrs", null) != null ? null : lookup(each.value, "lz_key", null) == null ? local.combined_objects_networking[local.client_config.landingzone_key][each.value.vnet_key] : local.combined_objects_networking[each.value.lz_key][each.value.vnet_key]
  settings        = each.value
  base_tags       = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
}

output "ip_groups" {
  value = module.ip_groups
}
