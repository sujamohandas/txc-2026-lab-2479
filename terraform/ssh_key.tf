##############################################################################
# ssh_key.tf
# Generates an RSA key pair, registers the public key with IBM Cloud VPC,
# and stores the private key in Vault (KV-v2) for later SSH access.
##############################################################################

# Generate a 4096-bit RSA key pair
resource "tls_private_key" "vsi" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key as a VPC SSH key in IBM Cloud
resource "ibm_is_ssh_key" "vsi" {
  name           = "${var.prefix}-${var.name}-key"
  public_key     = tls_private_key.vsi.public_key_openssh
  resource_group = var.resource_group_id
}

# Store the private key in Vault (KV-v2) so it can be retrieved for SSH access
resource "vault_kv_secret_v2" "vsi_private_key" {
  mount = "kv"
  name  = "vsi-private-key"

  data_json = jsonencode({
    private_key = tls_private_key.vsi.private_key_pem
  })
}
