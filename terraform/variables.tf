# -----------------------------------------------------------------------------
# Vault connection (passed as env vars in CI/CD — do not hardcode values)
# -----------------------------------------------------------------------------
variable "vault_addr" {
  description = "HCP Vault cluster public address (e.g. https://<cluster>.z1.hashicorp.cloud:8200)"
  type        = string
}

variable "vault_token" {
  description = "Vault token with read access to secret/ibmcloud"
  type        = string
  sensitive   = true
}

variable "vault_namespace" {
  description = "Vault namespace (default: admin for HCP Vault)"
  type        = string
  default     = "admin"
}

# -----------------------------------------------------------------------------
# IBM Cloud / resource configuration
# -----------------------------------------------------------------------------
variable "region" {
  description = "IBM Cloud region (e.g. us-south)"
  type        = string
  default     = "us-south"
}

variable "prefix" {
  description = "Prefix prepended to all resource names"
  type        = string
  default     = "demo"
}

variable "name" {
  description = "Base name for the VPC"
  type        = string
  default     = "vpc"
}

variable "resource_group_id" {
  description = "IBM Cloud resource group ID"
  type        = string
}

variable "image_id" {
  description = "VSI OS image ID. Run: ibmcloud is images --visibility public"
  type        = string
  # ibm-ubuntu-24-04-5-minimal-amd64-1 in us-south (confirmed available)
  default     = "r006-c892af9d-4058-4216-a56c-75eed4b9698b"
}

variable "machine_type" {
  description = "VSI profile. Run: ibmcloud is instance-profiles"
  type        = string
  default     = "cx2-2x4"
}

variable "resource_tags" {
  description = "User tags to apply to all resources"
  type        = list(string)
  default     = []
}
