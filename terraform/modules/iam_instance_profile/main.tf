terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.name
  role = var.role
}