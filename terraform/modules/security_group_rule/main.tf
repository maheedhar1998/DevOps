terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_security_group_rule" "sg_rule" {
  count = var.source_sg ? 1 : 0
  type = var.type
  from_port = var.from_port
  to_port = var.to_port
  protocol = var.protocol
  security_group_id = var.security_group_id
  source_security_group_id = var.source_sg_id
}

resource "aws_security_group_rule" "sg_rule_cidr" {
  count = var.source_sg ? 0 : 1
  type = var.type
  from_port = var.from_port
  to_port = var.to_port
  protocol = var.protocol
  security_group_id = var.security_group_id
  cidr_blocks = var.cidr_blocks
  ipv6_cidr_blocks = var.ipv6_cidr_blocks
}