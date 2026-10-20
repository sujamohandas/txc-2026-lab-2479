##############################################################################
# vault.tf
# Fetches the IBM Cloud API key from HCP Vault using a KV-v2 data source.
# The vault provider version in this workspace does not yet support ephemeral
# resources; using data "vault_kv_secret_v2" is the correct alternative.
# NOTE: Treat the Terraform state as sensitive — it will contain the secret.
##############################################################################

data "vault_kv_secret_v2" "ibmcloud" {
  mount = "kv"                # KV-v2 mount name (confirmed from lab Vault)
  name  = "IBM_CLOUD_API_KEY" # Secret path: kv/data/IBM_CLOUD_API_KEY
}
