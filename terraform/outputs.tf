output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = module.vpc.vpc_name
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.subnet_detail_map["zone-1"][0].id
}

output "vsi_list" {
  description = "List of VSIs with name, ID, zone, and primary private IP"
  value       = module.vsi.list
}

output "vsi_security_group" {
  description = "Security group attached to the VSI"
  value       = module.vsi.vsi_security_group
}

output "load_balancer_hostname" {
  description = "Public hostname of the Application Load Balancer — open in browser to see Nginx Hello World"
  value       = module.vsi.load_balancers_metadata["${var.prefix}-alb"].hostname
}
