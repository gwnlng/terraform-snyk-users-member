data "snyk_sso_connections" "sso_connections" {
  group_id = var.group_id
}

locals {
  sso_connections = data.snyk_sso_connections.sso_connections.connections
  # One data source per SSO connection so we get users from all connections.
  # a SSO connection is associated with a group so its length is 1.
  sso_connections_map = { for c in local.sso_connections : c.id => c }
}

# this DataSource returns all users from all SSO connections
data "snyk_sso_connection_users" "users" {
  for_each = local.sso_connections_map
  group_id = var.group_id
  sso_id   = each.key
}

locals {
  all_sso_users   = flatten([for ds in data.snyk_sso_connection_users.users : ds.users])
  # Map email -> user id for lookup from org_memberships JSON.
  email_to_user_id = { for u in local.all_sso_users : u.email => u.id }
}

output "sso_connection_id" {
  description = "Connection ID of a Group associated SSO connection."
  value = var.output_sso ? try(data.snyk_sso_connections.sso_connections.connections[0].id, null) : null
}

output "sso_connection_users" {
  description = "All SSO connection users."
  value = var.output_sso ? local.all_sso_users : null
}
