output "vpc_id" {
    description = "ID of the created vpc"
    value = aws_vpc.main.id
}

output "chosen db_backend"{
    description = "Which db option this stack is set to use later"
    value = var.db_backend
}