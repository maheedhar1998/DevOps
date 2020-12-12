provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}

module "VPC" {
  source = "../../modules/vpc"
  vpc_name = "QA_VPC"
  cidr_block = "10.13.0.0/16"
}

module "subnet_1" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  subnet_cidr_block = "10.13.1.0/24"
  name = "Main 10.13.1.0/24 ${module.VPC.vpc_id}"
}

module "subnet_2" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  subnet_cidr_block = "10.13.2.0/24"
  name = "Main 10.13.2.0/24 ${module.VPC.vpc_id}"
}

module "ec2" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_1.subnet_id
  name = "My WebServer QA"
  instance_type = "t2.micro"
}

module "s3" {
  source = "../../modules/s3"
  bucket = "my-load-balancer-logs-bucket-qa"
  acl = "public-read-write"
  name = "My bucket for ALB Logs"
}

module "ig" {
  source = "../../modules/internet_gateway"
  vpc_id = module.VPC.vpc_id
  name = "internet-gateway-qa"
}

module "load_balancer" {
  source = "../../modules/load_balancer"
  name = "Apllication-Load-Balancer-QA"
  internal = false
  lb_type = "application"
  subnets = [module.subnet_1.subnet_id, module.subnet_2.subnet_id]
  log_bucket = module.s3.bucket_name
  s3_prefix = "ALB_Logs_"
}
