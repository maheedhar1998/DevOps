resource "aws_key_pair" "my-ssh-key" {
  key_name  = var.name
  public_key = var.public_key
}