resource "aws_lb_target_group" "lb_target" {
  name = var.name
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id
  target_type = var.target_type
  load_balancing_algorithm_type = var.lb_algorithm
  deregistration_delay = 30
  health_check {
    enabled = true
    # interval = 5
    port = var.port
    protocol = var.health_check_protocol
    # timeout = 4
    path = var.path
  }
}