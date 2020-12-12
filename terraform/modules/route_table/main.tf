terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_route_table" "r" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}