data "snyk_roles" "all_roles" {
  group_id = var.group_id
}

# Map role name -> role public_id for lookup from org_memberships JSON.
locals {
  role_name_to_id = { for r in data.snyk_roles.all_roles.roles : r.name => r.public_id }
}
