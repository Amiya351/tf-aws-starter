# subnets.tf
resource "aws_subnet" "public" {
    count = length(local.azs)
    vpc_id = aws_vpc.main.id
    availability_zone = local.azs[count.index]
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-${count.index}"
        Tier = "public"
    }
}