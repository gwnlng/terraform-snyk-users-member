# Group details by group_id; used to supply group_id for snyk_group_membership and for slug/name outputs.
data "snyk_group" "this_group" {
  group_id = var.group_id
}

output "snyk_group" {
  value = var.output_group ? data.snyk_group.this_group : null
  description = "Snyk Group details."
}
