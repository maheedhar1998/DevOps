provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}
variable "vpc_names" {
    type = list(string)
}
variable "vpc_CIDRs" {
    type = list(string)
}
variable "vpc_subnet_CIDRs" {
    type = list(string)
}
module "VPC" {
    count = length(var.vpc_names)
    source = "./modules/vpc"
    vpc_name = var.vpc_names[count.index]
    cidr_block = var.vpc_CIDRs[count.index]
    subnet_cidr_block = var.vpc_subnet_CIDRs[count.index]
}
