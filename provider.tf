# Snyk User Terraform – snyk-labs/snyk-identity (local build from ../terraform-provider-snyk-identity).
# To use the local provider, set TF_CLI_CONFIG_FILE or ~/.terraformrc with dev_overrides; see README.
terraform {
  required_providers {
    snyk = {
      source  = "registry.terraform.io/snyk-labs/snyk-identity"
      version = ">= 0.1.0"
    }
  }
}

provider "snyk" {
  api_token = var.api_token
}
