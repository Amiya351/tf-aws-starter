# locals.tf
locals {
    # Use the first two AZs for now
    azs = slice(data.aws_availability_zones.available.names, 0, 2)

    # We created a /16 VPC(10.42.0.0/16). We'll carve /24 subnets from it
    # cidrsubnet(supernet, newbits, netnum)
    # newbits = 8 turns /16 into /24, netnum picks which /24
}