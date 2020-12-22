resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.name
  role = var.role
}