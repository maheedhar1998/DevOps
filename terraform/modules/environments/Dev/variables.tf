variable "vpc_name" {
    type = "Dev_VPC"
    description = "Name of the VPC"
}
variable "vpc_CIDR" {
    type = "10.11.0.0/16"
    description = "CIDR Block for the VPC"
}
variable "vpc_subnet_CIDR" {
    type = "10.11.1.0/24"
    description = "CIDR Block for the Subnet VPC"
}