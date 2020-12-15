terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_key_pair" "my-ssh-key" {
  key_name  = var.name
  public_key = var.public_key
}