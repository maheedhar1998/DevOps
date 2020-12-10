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

# resource "aws_s3_bucket" "main" {
#   bucket = "my-lb-log-bucket-maheedhar"
#   acl = "public-read"
#   tags = {
#     Name = "My LB Bucket"
#   }
# }

# resource "aws_lb" "main" {
#   name = "main_lb"
#   internal = false
#   load_balancer_type = "application"
#   subnets = [aws_subnet.main.id]
  
#   access_logs {
#     bucket = aws_s3_bucket.main
#     prefix = "main-LB"
#     enabled = true
#   }
# }

module "VPC" {
  source = "../"
}