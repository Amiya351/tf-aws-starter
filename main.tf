# Create a minimal VPC(free) we can see in the console, then destroy
resource "aws_vpc" "main" {
    cidr_block = "10.42.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = merge(var.tags, {
        Name = "${var.project_name}-vpc"
    })
}