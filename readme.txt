README - tf-aws-starter (line-by-line explanation)

This file documents every line of Terraform configuration in this project.

---
File: versions.tf
---
1 terraform {
2   required_version = ">=1.6.0"
3   required_providers {
4     aws = {
5       source  = "hashicorp/aws"
6       version = "~> 5.0"
7     }
8   }
9 }

Explanation:
- Line 1: Open the terraform block. This configures Terraform CLI behavior and provider constraints.
- Line 2: Sets the minimum Terraform CLI version required to run this code: 1.6.0 or greater.
- Line 3: Starts required_providers block where Provider dependencies are listed.
- Line 4: Declares provider alias key `aws` for the AWS provider.
- Line 5: Sets provider source to `hashicorp/aws` from registry.
- Line 6: Sets provider version compatibility to version 5.x (>=5.0, <6.0).
- Line 7: Closes aws provider map.
- Line 8: Closes required_providers block.
- Line 9: Closes terraform block.

---
File: providers.tf
---
1 provider "aws" {
2   region  = var.aws_region
3   profile = var.aws_profile
4
5   default_tags {
6     tags = var.tags
7   }
8 }

Explanation:
- Line 1: Declares the AWS provider block to configure AWS credentials and region.
- Line 2: Sets the AWS region from variable `aws_region`.
- Line 3: Sets the AWS CLI profile to use from variable `aws_profile`.
- Line 4: Blank line for readability.
- Line 5: Opens `default_tags` inner block for provider-level tag defaults.
- Line 6: Applies tags defined in variable `tags` to every resource that supports default tags.
- Line 7: Closes default_tags block.
- Line 8: Closes provider block.

---
File: variables.tf
---
1 variable "aws_region" {
2   type        = string
3   description = "AWS region to deploy into"
4   default     = "ap-south-1"
5 }
6 variable "aws_profile" {
7   type        = string
8   description = "AWS CLI profile to use"
9   default     = "tf-beginner"
10 }
11 variable "project_name" {
12   type        = string
13   description = "A short name for tagging and resource naming"
14   default     = "tf-aws-starter"
15 }
16 variable "tags" {
17   type        = map(string)
18   description = "Common tags for all resources"
19   default = {
20     Project     = "tf-aws-starter"
21     Environment = "dev"
22     Owner       = "Amiya"
23   }
24 }
25 variable "db_backend" {
26   type        = string
27   description = "Choose database backend for later lessons: rds or dynamodb"
28   default     = "dynamodb"
29   validation {
30     condition     = contains(["rds", "dynamodb"], var.db_backend)
31     error_message = "db_backend must be 'rds' or 'dynamodb'."
32   }
33 }

Explanation:
- Lines 1-5: Defines `aws_region` variable with type string, description, and default region.
- Lines 6-10: Defines `aws_profile` variable with recommended CLI profile name.
- Lines 11-15: Defines `project_name` variable used for naming resources and tags.
- Lines 16-24:
  - `tags` is a map of string to provide default tags.
  - `default` sets 3 common tags: Project, Environment, Owner.
- Lines 25-33:
  - `db_backend` variable allows selecting between `rds` or `dynamodb`.
  - `validation` block enforces the value is one of the allowed strings.
  - If invalid, Terraform plan/apply fails with error message.

---
File: datasources.tf
---
1 # datasources.tf
2 data "aws_availability_zones" "available" {
3   state = "available"
4 }

Explanation:
- Line 1: Comment header.
- Line 2: Declares a data source to fetch available AZ names in current region.
- Line 3: Filters zones to state = "available" to avoid deprecated/unavailable zones.
- Line 4: Ends data source block.

---
File: locals.tf
---
1 # locals.tf
2 locals {
3   # Use the first two AZs for now
4   azs = slice(data.aws_availability_zones.available.names, 0, 2)
5
6   # We created a /16 VPC(10.42.0.0/16). We'll carve /24 subnets from it
7   # cidrsubnet(supernet, newbits, netnum)
8   # newbits = 8 turns /16 into /24, netnum picks which /24
9 }

Explanation:
- Line 1: Comment header.
- Line 2: Begins a locals block for computed values.
- Line 3: Comment about using first two AZs.
- Line 4: Sets local `azs` to first two availability zones from data source.
- Line 5: Blank line.
- Lines 6-8: Notes about subnet addressing plan and cidrsubnet function usage.
- Line 9: Closes locals block.

---
File: main.tf
---
1 # Create a minimal VPC(free) we can see in the console, then destroy
2 resource "aws_vpc" "main" {
3   cidr_block           = "10.42.0.0/16"
4   enable_dns_hostnames = true
5   enable_dns_support   = true
6
7   tags = merge(var.tags, {
8     Name = "${var.project_name}-vpc"
9   })
10 }

Explanation:
- Line 1: Comment describing purpose (minimal VPC for learning and teardown).
- Line 2: Defines AWS VPC resource `main`.
- Line 3: VPC CIDR block set to 10.42.0.0/16.
- Line 4: Enables DNS hostnames in the VPC.
- Line 5: Enables DNS resolution within the VPC.
- Line 6: Blank line.
- Lines 7-9: Sets tags for the VPC by merging global tags with Name tag.
  - `merge()` combines `var.tags` and the inline map.
  - Name becomes `${project_name}-vpc`.
- Line 10: Closes VPC resource block.

---
File: subnets.tf
---
1 # subnets.tf
2 resource "aws_subnet" "public" {
3   count                   = length(local.azs)
4   vpc_id                  = aws_vpc.main.id
5   availability_zone       = local.azs[count.index]
6   cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
7   map_public_ip_on_launch = true
8
9   tags = {
10     Name = "${var.project_name}-public-${count.index}"
11     Tier = "public"
12   }
13 }

Explanation:
- Line 1: Comment header.
- Line 2: Defines aws_subnet resource set named `public`.
- Line 3: `count` makes one subnet per AZ in local.azs (2 subnets).
- Line 4: Attaches subnet to the VPC created above.
- Line 5: Places each subnet in a specific AZ by index.
- Line 6: Uses cidrsubnet to carve /24s from VPC /16. netnum is count.index so 0 and 1.
- Line 7: Sets subnets to assign public IPv4 addresses to new instances automatically.
- Lines 8-12: Tag each subnet with Name and Tier.
- Line 13: Ends subnet resource.

---
File: outputs.tf
---
1 output "vpc_id" {
2   description = "ID of the created vpc"
3   value       = aws_vpc.main.id
4 }
5
6 output "chosen_db_backend" {
7   description = "Which db option this stack is set to use later"
8   value       = var.db_backend
9 }
10
11 output "public_subnet_ids" {
12   description = "IDs of the public subnet"
13   value       = aws_subnet.public[*].id
14 }
15
16 output "public_subnet_cidrs" {
17   description = "CIDRs of the public subnets"
18   value       = aws_subnet.public[*].cidr_block
19 }
20
21 output "azs_used" {
22   description = "Availability Zones used for the public subnets"
23   value       = local.azs
24 }

Explanation:
- Lines 1-4: `vpc_id` output to expose the created VPC ID.
- Lines 6-9: `chosen_db_backend` output to expose variable value for backend choice.
- Lines 11-14: `public_subnet_ids` output list of created public subnet IDs.
- Lines 16-19: `public_subnet_cidrs` output list of CIDR blocks for the public subnets.
- Lines 21-24: `azs_used` output list of AZs in use.

---
File: dev.tfvars
---
This file is not Terraform config but variable values for this environment.
- aws_region = "ap-south-1" (region to deploy)
- aws_profile = "tf-beginner" (local AWS CLI profile)
- project_name = "tf-aws-starter-dev" (resource naming prefix)
- tags are set with Project/Environment/Owner.
- db_backend = "dynamodb" (backend selection for later modules)

Usage:
Run `terraform apply -var-file=dev.tfvars` to use these values.

---

How to use:
1. terraform init
2. terraform plan -var-file=dev.tfvars
3. terraform apply -var-file=dev.tfvars
4. terraform destroy -var-file=dev.tfvars
