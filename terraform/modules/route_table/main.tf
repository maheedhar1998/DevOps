resource "aws_route_table" "r" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}