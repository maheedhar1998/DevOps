provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}

module "VPC" {
  source = "./modules/vpc"
  vpc_name = var.vpc_names
  cidr_block = var.vpc_CIDRs
  subnet_cidr_block = var.vpc_subnet_CIDRs
}
# module "subnet" {

# }
