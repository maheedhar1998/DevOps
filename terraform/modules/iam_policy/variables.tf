variable "name" {
  type = string
  description = "Name of the IAM Policy"
}
variable "description" {
  type = string
  description = "IAM Policy description"
}
variable "policy" {
  type = string
  description = "JSON formatted policy document"
  default = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
  POLICY
}