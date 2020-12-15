terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = var.name
  }
}