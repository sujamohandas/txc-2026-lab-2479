#!/usr/bin/env bash
#
# break-lab-app.sh
# TechXchange 2026 Lab 2479 - "Break the environment" script
#
# What it does:
#   Removes the security group's inbound rule that allows TCP traffic on
#   port 80, and adds a rule for a different port (8080) instead. The
#   Nginx "hello world" app is untouched and still listening on port 80
#   inside the VSI -- only the security group now blocks it -- so the
#   app becomes unreachable at the load balancer's public address.
#
#   This is a pure Terraform-managed resource change, so the next
#   `terraform plan` will show it as drift. That's what BOB uses (via
#   the Terraform MCP server) to diagnose the issue in Major Task 2.
#
# Requirements:
#   - IBM Cloud CLI (`ibmcloud`) installed and logged in
#       ibmcloud login --sso
#   - VPC infrastructure plugin installed
#       ibmcloud plugin install vpc-infrastructure
#   - Target region and resource group already set for this session
#       ibmcloud target -r <region> -g <resource-group>
#   - `jq` installed (used to parse rule output)
#
# Usage:
#   ./break-lab-app.sh <security-group-name-or-id>
#
# Example:
#   ./break-lab-app.sh lab-2479-app-sg

set -euo pipefail

SG="${1:-}"

if [[ -z "$SG" ]]; then
  echo "Usage: $0 <security-group-name-or-id>"
  exit 1
fi

echo "Looking up the inbound TCP:80 rule on security group '$SG'..."

RULE_ID=$(ibmcloud is security-group-rules "$SG" --output json \
  | jq -r '.[] | select(.direction=="inbound" and .protocol=="tcp" and .port_min==80 and .port_max==80) | .id' \
  | head -n 1)

if [[ -z "$RULE_ID" || "$RULE_ID" == "null" ]]; then
  echo "No inbound TCP:80 rule found on security group '$SG'."
  echo "Nothing to break -- check the security group name/ID and try again."
  exit 1
fi

echo "Found rule $RULE_ID. Removing inbound access on port 80..."
ibmcloud is security-group-rule-delete "$SG" "$RULE_ID" -f

echo "Adding a replacement inbound rule on port 8080 instead of 80..."
ibmcloud is security-group-rule-add "$SG" inbound tcp --port-min 8080 --port-max 8080 --remote 0.0.0.0/0

cat <<'EOF'

Done. The environment is now broken:
  - Port 80 inbound is blocked at the security group.
  - The Nginx app inside the VSI is untouched and still listening on port 80.
  - The load balancer / VSIs / app configuration are otherwise unchanged.

This is purely a security-group-level change, so it will show up as
infrastructure drift the next time `terraform plan` runs. In BOB, ask:

    "This application is not working, can you help troubleshoot?"

EOF