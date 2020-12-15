terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_lb_target_group" "lb_target" {
  name = var.name
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id
  target_type = var.target_type
  load_balancing_algorithm_type = var.lb_algorithm
}