variable "vpc_name" {
    type = "Dev_VPC"
    description = "Name of the VPC"
}
variable "vpc_CIDR" {
    type = "10.11.0.0/16"
    description = "CIDR Block for the VPC"
}
variable "vpc_id" {
  type = ""
  description = "ID of the VPC that the subnet is in."
}
variable "subnet_cidr_block" {
  type = "10.11.1.0/24"
  description = "CIDR Block for the Subnet VPC"
}
variable "subnet_name" {
  type = "Main ${var.vpc_id}"
  description = "Name of the Subnet"
}