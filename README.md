# Terraform Snyk User Provisioning

Terraform configuration that manages Snyk users [Organizations](https://docs.snyk.io/snyk-platform-administration/groups-and-organizations/organizations) and [Groups](https://docs.snyk.io/snyk-platform-administration/groups-and-organizations/groups) memberships.

# Usage

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- Snyk API token or [Service Account](https://docs.snyk.io/snyk-platform-administration/service-accounts) token assigned **Group Admin** or Group-level [custom role](https://docs.snyk.io/snyk-platform-administration/user-roles/user-role-management#manage-roles) with selected [Group-level](https://docs.snyk.io/snyk-platform-administration/user-roles/pre-defined-roles#group-level-permissions)**and** [Organization-level](https://docs.snyk.io/snyk-platform-administration/user-roles/pre-defined-roles#organization-level-permissions) permissions:

| Scope | Permission |
|-------|------------|
| Group | View SSO settings |
| Group | Read Roles |
| Group | View users |
| Group | Add users to Group |
| Group | Provision Users |
| Group | Edit users in Group |
| Group | Remove users |
| Group | Delete users |
| Group | Assign and Unassign Roles |
| Org | View Users |
| Org | Invite Users |
| Org | Manage Users |
| Org | Add Users |
| Org | Provision Users |
| Org | User Leave |
| Org | User Remove |

> [!IMPORTANT]<br>
> In addition to above permissions, this `api_token` assigned Role must also possess equivalent permissions of a user's provisioned Role.
> This is to avoid 403 Permission denied errors when using custom roles.

## Provider configuration

Declare the provider and pass a Snyk API token. Optional `api_endpoint` sets the API host (for example `api.snyk.io`); if you omit a scheme, `https://` is prepended. When unset, the client uses `https://api.snyk.io`.

```hcl
terraform {
  required_providers {
    snyk = {
      source  = "snyk-labs/snyk-identity"
      version = "~> 0.1"
    }
  }
}

provider "snyk" {
  api_token = var.api_token
  # optional Snyk API endpoint variable
  # api_endpoint = "api.snyk.io"
}
```

## Terraform Configuration

> [!NOTE]<br>
> The Snyk users must first be created on Snyk tenant through [Configure Self-Serve Single Sign-On (SSO)](https://docs.snyk.io/snyk-platform-administration/single-sign-on-sso-for-authentication-to-snyk/configure-self-serve-single-sign-on-sso) with SCIM provisioning prior to Terraform execution of assigning memberships.

1. Copy the example JSON configuration files in the examples folder to its parent folder.
2. Populate the [all_group_roles.json](examples/all_group_roles.json) with a list of object of Role ID, Role Name based on Snyk WebUI (Group) > Settings > Member Roles (Group).
3. Populate the [all_memberships.json](examples/all_memberships.json) with a list of object of User email address to their respective Snyk Organization(s) or Snyk Group and Roles(s).
4. Rename terraform.tfvars.example as `terraform.tfvars` with specified values.
5. Launch Terraform with:

```bash
terraform init
terraform plan -input=false -out=tfplan
terraform apply "tfplan"
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_snyk"></a> [snyk](#requirement\_snyk) | >= 0.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snyk"></a> [snyk](#provider\_snyk) | >= 0.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| snyk_group_membership.member | resource |
| snyk_org_membership.member | resource |
| snyk_group.this_group | data source |
| snyk_orgs.group_orgs | data source |
| snyk_roles.all_roles | data source |
| snyk_sso_connection_users.users | data source |
| snyk_sso_connections.sso_connections | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_all_group_roles_file"></a> [all\_group\_roles\_file](#input\_all\_group\_roles\_file) | Path to JSON file defining allowed group role names and IDs. Schema: [{ "role\_id", "role\_name" }, ...]. Used to map group membership role\_name to role\_id. | `string` | `"all_group_roles.json"` | no |
| <a name="input_all_memberships_file"></a> [all\_memberships\_file](#input\_all\_memberships\_file) | Path to JSON file. Each object: "org\_slug" or "group\_slug"; "role\_name"; "email". Optional: "cascade\_delete" for group. Org role\_id from snyk\_roles; group role\_id from all\_group\_roles\_file. | `string` | `"all_memberships.json"` | no |
| <a name="input_api_endpoint"></a> [api\_endpoint](#input\_api\_endpoint) | Snyk API endpoint. Leave empty to use https://api.snyk.io | `string` | `"api.snyk.io"` | no |
| <a name="input_api_token"></a> [api\_token](#input\_api\_token) | Snyk API token (needs org.membership.add and/or group.membership.add as needed). | `string` | n/a | yes |
| <a name="input_group_id"></a> [group\_id](#input\_group\_id) | Snyk group UUID. Required for lookups (SSO users, orgs, roles) and for group membership entries (snyk\_group provides group details from this id). | `string` | `""` | yes |
| <a name="input_output_group"></a> [output\_group](#input\_output\_group) | Show group in output. | `bool` | `false` | no |
| <a name="input_output_memberships"></a> [output\_memberships](#input\_output\_memberships) | Show memberships in output. | `bool` | `false` | no |
| <a name="input_output_orgs"></a> [output\_orgs](#input\_output\_orgs) | Show orgs in output. | `bool` | `false` | no |
| <a name="input_output_sso"></a> [output\_sso](#input\_output\_sso) | Show Single Sign-On connection details in output. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_req_group_membership_list"></a> [req\_group\_membership\_list](#output\_req\_group\_membership\_list) | List of requested group memberships. |
| <a name="output_req_org_membership_list"></a> [req\_org\_membership\_list](#output\_req\_org\_membership\_list) | List of requested org memberships. |
| <a name="output_snyk_group"></a> [snyk\_group](#output\_snyk\_group) | Snyk Group details. |
| <a name="output_snyk_orgs"></a> [snyk\_orgs](#output\_snyk\_orgs) | List of Snyk orgs in the group. |
| <a name="output_sso_connection_id"></a> [sso\_connection\_id](#output\_sso\_connection\_id) | Connection ID of a Group associated SSO connection. |
| <a name="output_sso_connection_users"></a> [sso\_connection\_users](#output\_sso\_connection\_users) | All SSO connection users. |
<!-- END_TF_DOCS -->