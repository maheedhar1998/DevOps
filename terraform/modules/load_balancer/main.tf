terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_lb" "main" {
  name = var.name
  internal = var.internal
  load_balancer_type = var.lb_type
  subnets = var.subnets
  
  access_logs {
    bucket = var.log_bucket
    prefix = var.s3_prefix
    enabled = true
  }
}