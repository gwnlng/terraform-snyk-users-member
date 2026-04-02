# Single file for all memberships. Each object has either org_slug (org membership) or group_slug (group membership).
# Org: org_id from snyk_orgs; role_id from snyk_roles. Group: group_id from snyk_group; role_id from all_group_roles.json. user_id from SSO.
locals {
  group_role_name_to_id = { for r in jsondecode(file(var.all_group_roles_file)) : r.role_name => r.role_id }
  all_memberships       = jsondecode(file(var.all_memberships_file))
  org_memberships_map   = { for i, m in local.all_memberships : tostring(i) => m if try(m.org_slug, null) != null }
  group_memberships_map = { for i, m in local.all_memberships : tostring(i) => m if try(m.group_slug, null) != null }
  org_ids               = toset([for o in data.snyk_orgs.group_orgs.orgs : o.id])
}

# Org membership: provisioned when the JSON object has org_slug. group_id (for lookups) comes from var.group_id.
resource "snyk_org_membership" "member" {
  for_each = local.org_memberships_map

  org_id  = local.slug_to_org_id[each.value.org_slug]
  user_id = local.email_to_user_id[each.value.email]
  role_id = local.role_name_to_id[each.value.role_name]
}

# Group membership: provisioned when the JSON object has group_slug. role_id from all_group_roles.json (role_name -> role_id).
resource "snyk_group_membership" "member" {
  for_each = local.group_memberships_map

  group_id       = data.snyk_group.this_group.id
  user_id        = local.email_to_user_id[each.value.email]
  role_id        = local.group_role_name_to_id[each.value.role_name]
  cascade_delete = try(each.value.cascade_delete, false)
}

output "req_group_membership_list" {
  value       = var.output_memberships ? values(local.group_memberships_map) : null
  description = "List of requested group memberships."
}

output "req_org_membership_list" {
  value       = var.output_memberships ? values(local.org_memberships_map) : null
  description = "List of requested org memberships."
}
