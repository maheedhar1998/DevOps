variable "vpc_name" {
    type = "QA_VPC"
    description = "Name of the VPC"
}
variable "vpc_CIDR" {
    type = "10.13.0.0/16"
    description = "CIDR Block for the VPC"
}
variable "vpc_subnet_CIDR" {
    type = "10.13.1.0/24"
    description = "CIDR Block for the Subnet VPC"
}