terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
resource "aws_nat_gateway" "gw" {
  allocation_id = var.eip_id
  subnet_id = var.subnet_id
  tags = {
    Name = var.name
  }
}