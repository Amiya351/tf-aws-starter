output "vpc_id" {
  description = "ID of the created vpc"
  value       = aws_vpc.main.id
}

output "chosen_db_backend" {
  description = "Which db option this stack is set to use later"
  value       = var.db_backend
}

output "public_subnet_ids" {
    description = "IDs of the public subnet"
    value = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "CIDRs of the public subnets"
  value = aws_subnet.public[*].cidr_block
}

output "azs_used" {
    description = "Availability Zones used for the public subnets"
    value = local.azs
}