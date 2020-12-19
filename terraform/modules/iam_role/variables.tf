variable "name" {
  type = string
  description = "Name of the Role"
}
variable "assume_role_policy" {
  type = string
  description = "Policy to attach to the role"
  default = <<EOF
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
    EOF
}