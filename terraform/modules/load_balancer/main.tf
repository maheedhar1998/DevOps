resource "aws_lb" "main" {
  name = var.name
  internal = var.internal
  load_balancer_type = var.lb_type
  subnets = var.subnets
  security_groups = var.security_groups
  access_logs {
    bucket = var.log_bucket
    prefix = var.s3_prefix
    enabled = true
  }
}