resource "aws_network_interface" "enic" {
  subnet_id = var.subnet_id
  private_ips = var.private_ips
  security_groups = var.security_groups
  tags = {
    Name = var.name
  }
}