output "vpc_id" {
  description = "ID of the Kubernetes VPC."
  value       = aws_vpc.kubernetes.id
}

output "vpc_cidr" {
  description = "CIDR block of the Kubernetes VPC."
  value       = aws_vpc.kubernetes.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.kubernetes.id
}

output "public_subnet_ids" {
  description = "IDs of the three public subnets."
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the three public subnets."
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_availability_zones" {
  description = "Availability Zones of the three public subnets."
  value       = aws_subnet.public[*].availability_zone
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "kubernetes_security_group_id" {
  description = "Security group ID used by Kubernetes nodes."
  value       = aws_security_group.kubernetes.id
}
