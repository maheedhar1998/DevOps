resource "aws_iam_role" "new_role" {
  name = var.name
  assume_role_policy = var.assume_role_policy
}