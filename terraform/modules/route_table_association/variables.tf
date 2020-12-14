variable "sub" {
  type = bool
  description = "Whether or not the Route Table is associated with a subnet"
}
variable "subnet_id" {
  type = string
  description = "The ID of the subnet to associate with"
  default = ""
}
variable "gateway_id" {
  type = string
  description = "The ID of the gateway to associate with"
  default = ""
}
variable "route_table_id" {
  type = string
  description = "ID of the route table"
}