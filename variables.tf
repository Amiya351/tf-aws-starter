variable "aws_region"{
    type = string
    description = "AWS region to deploy into"
    default = "ap-south-1"
}
variable "aws_profile"{
    type = "string"
    description = "AWS CLI profile to use"
    default = "tf-beginner"
}
variable "project_name" {
    type = string
    description = "A short name for tagging and resource naming"
    default = "tf-aws-starter"
}
variable "tags" {
    type = map(string)
    description = "Common tags for all resources"
    default = {
        Project = "tf-aws-starter"
        Environment = "dev"
        Owner = "Amiya"
    }
}
variable "db_backend" {
    type = string
    description = "Choose database backend for later lessons: rds or dynamodb"
    default = "dynamodb"
    validation {
      condition = contains(["rds","dynamodb"], var.db_backend)
      error_message = "db_backend must be 'rds' or 'dynamodb'."
    }
}