terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  count = length(var.target_ids)
  target_group_arn = var.target_group_arn
  target_id = var.target_ids[count.index]
  port = var.port
}