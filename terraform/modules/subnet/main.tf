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
  availability_zone_id = var.az_id
  map_public_ip_on_launch = var.auto_public_ip
  tags = {
    Name = var.name
  }
}