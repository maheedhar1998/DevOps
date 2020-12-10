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
  # vpc_id = VPC.aws_vpc.
}

module "ec2" {
  source = "./modules/ec2"

}

# module "s3" {
#   source = "./modules/s3"

# }

# module "load_balancer" {
#   source = "./modules/load_balancer"

# }