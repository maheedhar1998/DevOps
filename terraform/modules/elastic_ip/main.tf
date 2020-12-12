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
  network_interface = var.network_interface_id
  tags = {
    Name = var.name
  }
}