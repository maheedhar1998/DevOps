variable "vpc_name" {
  type = string
  description = "VPC name"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}

resource "aws_vpc" "main" {
  cidr_block = "10.11.0.0/16"
  instance_tenancy = "default"
  tags = {
    "Name" = var.vpc_name
  }
}