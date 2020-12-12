terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_network_interface" "enic" {
  subnet_id = var.subnet_id
  private_ips = var.private_ips
  security_groups = var.security_groups
  tags = {
    Name = var.name
  }
}