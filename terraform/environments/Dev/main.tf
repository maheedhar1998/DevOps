provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}

module "VPC" {
  source = "../../modules/vpc"
  vpc_name = "Dev_VPC"
  cidr_block = "10.11.0.0/16"
}

module "subnet_1" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  subnet_cidr_block = "10.11.1.0/24"
  name = "Main 10.11.1.0/24 ${module.VPC.vpc_id}"
}

module "route_table_sub_1" {
  source = "../../modules/route_table"
  name = "Public Subnet Route Table"
  vpc_id = module.VPC.vpc_id
}

module "route_1_sub1" {
  source = "../../modules/route"
  route_table_id = module.route_table_sub_1.route_table_id
  nat = false
  dest_cidr = "0.0.0.0/0"
  gateway_id = module.ig.internet_gateway_id
}

module "route_table_sub_1_association" {
  source = "../../modules/route_table_association"
  sub = true
  subnet_id = module.subnet_1.subnet_id
  route_table_id = module.route_table_sub_1.route_table_id
}

module "subnet_2" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  subnet_cidr_block = "10.11.2.0/24"
  name = "Main 10.11.2.0/24 ${module.VPC.vpc_id}"
}

module "route_table_sub_2" {
  source = "../../modules/route_table"
  name = "Private Subnet Route Table"
  vpc_id = module.VPC.vpc_id
}

module "route_1_sub2" {
  source = "../../modules/route"
  route_table_id = module.route_table_sub_1.route_table_id
  nat = true
  dest_cidr = "0.0.0.0/0"
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

module "route_table_sub_2_association" {
  source = "../../modules/route_table_association"
  sub = true
  subnet_id = module.subnet_2.subnet_id
  route_table_id = module.route_table_sub_2.route_table_id
}

module "ec2" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_1.subnet_id
  name = "My WebServer Dev"
  instance_type = "t2.micro"
}

module "s3" {
  source = "../../modules/s3"
  bucket = "my-load-balancer-logs-bucket-dev"
  acl = "public-read-write"
  name = "My bucket for ALB Logs"
}

module "ig" {
  source = "../../modules/internet_gateway"
  vpc_id = module.VPC.vpc_id
  name = "internet-gateway-dev"
}

module "elastic_ip" {
  source = "../../modules/elastic_ip"
  name = "NAT Gateway Elastic IP"
  network_interface_id = ""# TODO Network Interfaces
}

module "nat_gateway" {
  source = "../../modules/nat_gateway"
  name = "NAT Gateway Dev"
  eip_id = module.elastic_ip.id
  subnet_id = module.subnet_1.subnet_id
}

module "load_balancer" {
  source = "../../modules/load_balancer"
  name = "Apllication-Load-Balancer-Dev"
  internal = false
  lb_type = "application"
  subnets = [module.subnet_1.subnet_id, module.subnet_2.subnet_id]
  log_bucket = module.s3.bucket_name
  s3_prefix = "ALB_Logs_"
}