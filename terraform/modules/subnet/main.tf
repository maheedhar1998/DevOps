terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_subnet" "main" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  tags = {
    Name = var.name
  }
}