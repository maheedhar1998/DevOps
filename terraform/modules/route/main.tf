resource "aws_route" "r1" {
  count = var.nat ? 0 : 1
  route_table_id = var.route_table_id
  destination_cidr_block = var.dest_cidr
  gateway_id = var.gateway_id
}

resource "aws_route" "r2" {
  count = var.nat ? 1 : 0
  route_table_id = var.route_table_id
  destination_cidr_block = var.dest_cidr
  nat_gateway_id = var.nat_gateway_id
}