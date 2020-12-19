terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_iam_policy" "policy" {
  name = var.name
  description = var.description
  policy = var.policy
}