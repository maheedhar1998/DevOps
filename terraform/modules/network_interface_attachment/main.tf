terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_network_interface_attachment" {
  instance_id = var.instance_id
  network_interface_id = var.network_interface_id
  device_index = var.device_index
}