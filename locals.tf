# locals.tf
#locals {
# Use the first two AZs for now
#  azs = slice(data.aws_availability_zones.available.names, 0, 2)

# We created a /16 VPC(10.42.0.0/16). We'll carve /24 subnets from it
# cidrsubnet(supernet, newbits, netnum)
# newbits = 8 turns /16 into /24, netnum picks which /24
#}

locals {
  # Derive a consistent name prefix from project and environment tag
  name_prefix = "${var.project_name}-${var.tags["Environment"]}"

  # Take the first N AZs in this region
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Precompute the public subnets CIDRs we will use (one per AZ)
  public_subnet_cidrs = [
    for i in range(var.az_count) :
    cidrsubnet(var.vpc_cidr, var.public_subnet_newbits, i)
  ]
}