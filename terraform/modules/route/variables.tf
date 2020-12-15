variable "route_table_id" {
  type = string
  description = "Route Table ID to Associate the Route to"
}
variable "dest_cidr" {
  type = string
  description = "The Destination CIDR Block"
}
variable "gateway_id" {
  type = string
  description = "The ID of a VPC Internet Gateway or a Virtual Private Gateway"
  default = ""
}
variable "nat_gateway_id" {
  type = string
  description = "The ID of the NAT Gateway"
  default = ""
}
variable "nat" {
  type = bool
  description = "Determine if the connected gateway is NAT or Internet"
}
