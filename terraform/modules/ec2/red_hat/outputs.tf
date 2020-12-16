output "instance_ids" {
  value = aws_instance.red_hat_instance.*.id
}