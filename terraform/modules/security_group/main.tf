terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_security_group" "sg" {
  name = var.name
  description = var.sg_description
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}