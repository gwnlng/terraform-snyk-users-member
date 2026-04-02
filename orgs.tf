data "snyk_orgs" "group_orgs" {
  group_id = var.group_id
}

# Map org slug -> org id for lookup from org_memberships JSON.
locals {
  slug_to_org_id = { for o in data.snyk_orgs.group_orgs.orgs : o.slug => o.id }
}

output "snyk_orgs" {
  value = var.output_orgs ? data.snyk_orgs.group_orgs.orgs : null
  description = "List of Snyk orgs in the group."
}
