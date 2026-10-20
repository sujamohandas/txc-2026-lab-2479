##############################################################################
# providers.tf
# Vault + IBM Cloud provider config.
# IBM Cloud API key is fetched LIVE from HCP Vault via an ephemeral resource —
# it is NEVER written to Terraform state.
##############################################################################

terraform {
  required_version = ">= 1.10.0"

  cloud {
    organization = "TechX-2026"
    workspaces {
      name = "vsi_vpc_2479"
    }
  }

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 2.5.0, < 3.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.4.0, < 5.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.4.0, < 5.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1, < 1.0.0"
    }
  }
}

# ---------------------------------------------------------------------------
# Vault provider — credentials supplied via environment variables or
# sensitive workspace variables in HCP Terraform:
#   TF_VAR_vault_addr      = https://<cluster>.z1.hashicorp.cloud:8200
#   TF_VAR_vault_token     = <token>   (mark sensitive in HCP Terraform UI)
#   TF_VAR_vault_namespace = admin
# ---------------------------------------------------------------------------
provider "vault" {
  address   = var.vault_addr
  token     = var.vault_token
  namespace = var.vault_namespace
}

# ---------------------------------------------------------------------------
# IBM Cloud provider — API key sourced from the ephemeral Vault resource.
# ephemeral resources are NOT written to state, making this the most secure
# approach for injecting secrets at plan/apply time.
# ---------------------------------------------------------------------------
provider "ibm" {
  ibmcloud_api_key = data.vault_kv_secret_v2.ibmcloud.data["IBM_KEY"]
  region           = var.region
}
