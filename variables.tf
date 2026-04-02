variable "api_token" {
  type        = string
  sensitive   = true
  description = "Snyk API token (needs org.membership.add and/or group.membership.add as needed)."
}

variable "api_endpoint" {
  type        = string
  default     = "api.snyk.io"
  description = "Snyk API endpoint. Leave empty to use https://api.snyk.io"
}

# --- All memberships: single JSON file. Objects with org_slug -> org membership; with group_slug -> group membership ---
variable "all_memberships_file" {
  type        = string
  default     = "all_memberships.json"
  description = "Path to JSON file. Each object: \"org_slug\" or \"group_slug\"; \"role_name\"; \"email\". Optional: \"cascade_delete\" for group. Org role_id from snyk_roles; group role_id from all_group_roles_file."
}

# --- Group membership roles: role_name -> role_id for group membership entries (see all_group_roles.json schema) ---
variable "all_group_roles_file" {
  type        = string
  default     = "all_group_roles.json"
  description = "Path to JSON file defining allowed group role names and IDs. Schema: [{ \"role_id\", \"role_name\" }, ...]. Used to map group membership role_name to role_id."
}

# --- Group context: required for SSO user lookup, orgs, roles, and for snyk_group (group_slug entries use this group) ---
variable "group_id" {
  type        = string
  default     = ""
  description = "Snyk group UUID. Required for lookups (SSO users, orgs, roles) and for group membership entries (snyk_group provides group details from this id)."
}

variable "output_orgs" {
  type        = bool
  default     = false
  description = "Show orgs in output."
}

variable "output_group" {
  type        = bool
  default     = false
  description = "Show group in output."
}

variable "output_sso" {
  type        = bool
  default     = false
  description = "Show Single Sign-On connection details in output."
}

variable "output_memberships" {
  type        = bool
  default     = false
  description = "Show memberships in output."
}
