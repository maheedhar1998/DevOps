terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resources "aws_route_table_association" "subnet_ass" {
  count = var.sub ? 1 : 0
  subnet_id = var.subnet_id
  route_table_id = var.route_table_id
}

resources "aws_route_table_association" "gateway_ass" {
  count = var.sub ? 0 : 1
  gateway_id = var.gateway_id
  route_table_id = var.route_table_id
}