terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = var.load_balancer_arn
  port = var.port
  protocol = var.protocol
  default_action {
    type = "forward"
    target_group_arn = var.target_group_arn
  }
}