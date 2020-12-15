output "target_group_id" {
  value = aws_lb_target_group.lb_target.id
}
output "target_group_arn" {
  value = aws_lb_target_group.lb_target.arn
}