terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"
  tags = {
    "Name" = var.vpc_name
  }
}