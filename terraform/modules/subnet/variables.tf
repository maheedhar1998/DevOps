variable "vpc_id" {
  type = string
  description = "ID of the VPC that the subnet is in."
}
variable "subnet_cidr_block" {
  type = string
  description = "subnet CIDR block"
}
variable "name" {
  type = string
  description = "Name of the Subnet"
}
variable "az_id" {
  type = string
  description = "The ID of the AVialability Zone to place the subnet in"
}