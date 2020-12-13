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

module "security_group_sub1" {
  source = "../../modules/security_group"
  description = "public-security-group"
  vpc_id = module.VPC.vpc_id
}

module "security_group_1_rule_1" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = module.security_group_sub1.security_group_id
  cidr_blocks = "0.0.0.0/0"
  ipv6_cidr_blocks = "::/0"
}

module "security_group_1_rule_2" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = module.security_group_sub1.security_group_id
  cidr_blocks = "0.0.0.0/0"
  ipv6_cidr_blocks = "::/0"
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

module "security_group_sub2" {
  source = "../../modules/security_group"
  description = "private-security-group"
  vpc_id = module.VPC.vpc_id
}

module "security_group_2_rule_1" {
  source = "../../modules/security_group_rule"
  source_sg = true
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = module.security_group_sub2.security_group_id
  source_sg_id = module.security_group_sub1.security_group_id
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

module "ec2_0" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_2.subnet_id
  name = "My WebServer Dev 1"
  instance_type = "t2.micro"
  vpc_security_group_ids = []
}

module "ec2_1" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_2.subnet_id
  name = "My WebServer Dev 2"
  instance_type = "t2.micro"
  vpc_security_group_ids = []
}

module "ec2_2" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_2.subnet_id
  name = "My WebServer Dev 3"
  instance_type = "t2.micro"
  vpc_security_group_ids = []
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
  network_interface_id = module.network_interface.network_interface_id
}

module "network_interface" {
  source = "../../modules/network_interface"
  name = "NAT Elastic Network Interface"
  subnet_id = module.subnet_2.subnet_id
  private_ips = ["10.11.2.50"]
  security_groups = [] # TODO Security Group Association
}

module "network_interface_attachment_1" {
  instance_id = module.ec2_0.instance_id
  network_interface_id = module.network_interface.network_interface_id
  device_index = 0
}

module "network_interface_attachment_2" {
  instance_id = module.ec2_1.instance_id
  network_interface_id = module.network_interface.network_interface_id
  device_index = 1
}

module "network_interface_attachment_3" {
  instance_id = module.ec2_2.instance_id
  network_interface_id = module.network_interface.network_interface_id
  device_index = 2
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