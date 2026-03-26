variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "ap-south-1"
}
variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use"
  default     = "tf-beginner"
}
variable "project_name" {
  type        = string
  description = "A short name for tagging and resource naming"
  default     = "tf-aws-starter"
}
variable "tags" {
  type        = map(string)
  description = "Common tags for all resources"
  default = {
    Project     = "tf-aws-starter"
    Environment = "dev"
    Owner       = "Amiya"
  }
}
variable "db_backend" {
  type        = string
  description = "Choose database backend for later lessons: rds or dynamodb"
  default     = "dynamodb"
  validation {
    condition     = contains(["rds", "dynamodb"], var.db_backend)
    error_message = "db_backend must be 'rds' or 'dynamodb'."
  }
}

# VPC CIDR as input (we used 10.42.0.0/16 earlier)
variable  "vpc_cidr" {
    type = string
    description = "CIDR block for the VPC"
    default = "10.42.0.0/16"

    # Validate it's a proper CIDR by trying a harmless cidrsubnet
    validation {
      condition = can(cidrsubnet(var.vpc_cidr, 0, 0))
      error_message = "vpc_cidr must be a valid IPv4 CIDR, e.g. 10.42.0.0/16."
    }
}

# How many AZs/subnet we want to use right now
variable "az_count" {
    type = number
    description = "How many Availability Zones (and subnets) to create"
    default = 2
    validation {
      condition = contains([1,2,3], var.az_count)
      error_message = "az_count must be 1,2, or 3 for this starter."
    }
}

# Subnetting: how many new bits to carve /24s (8) out of /16 (16+8=24)
variable "public_subnet_newbits" {
  type = number
  description = "Number of new bits to carve public subnets from the VPC CIDR (8 turns /16 into /24s)"
  default = 8
  validation {
    condition = var.public_subnet_newbits >= 4 && var.public_sunets_newbits >= 12
    error_message = "public_subnet_newbits should be between 4 and 12"
  }
}

# Placeholder for later (RDS). Declared now so you see 'sensitive' vars
# They are not used yet, so you don't have to set them now.
variable "db_username" {
  type = string
  description = "RDS username (used only when db_backend = \"rds\")"
  sensitive = true
  default = null
}
variable "db_password" {
    type = string
    description = "RDS password (used only when db_backend = \"rds\")"
    sensitive = true
    default = null
}
