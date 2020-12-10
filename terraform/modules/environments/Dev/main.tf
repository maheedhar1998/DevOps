provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}

module "VPC" {
  source = "./modules/vpc"
  vpc_name = var.vpc_names
  cidr_block = var.vpc_CIDRs
}

module "subnet" {
  source = "./modules/subnets"
  vpc_id = module.VPC.aws_vpc.vpc_id
  subnet_cidr_block = var.subnet_cidr_block
  name = var.subnet_name
}

# module "ec2" {
#   source = "./modules/ec2"

# }

# module "s3" {
#   source = "./modules/s3"

# }

# module "load_balancer" {
#   source = "./modules/load_balancer"

# }