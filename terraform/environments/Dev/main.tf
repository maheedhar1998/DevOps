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

module "availability_zones" {
  source = "../../modules/availability_zones"
}

module "subnet_1" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  subnet_cidr_block = "10.11.1.0/24"
  name = "Main 10.11.1.0/24 ${module.VPC.vpc_id}"
  az_id = module.availability_zones.availability_zones[0]
}

module "security_group_sub1" {
  source = "../../modules/security_group"
  sg_description = "public-security-group"
  vpc_id = module.VPC.vpc_id
  name = "public-security-group"
}

module "security_group_1_rule_1" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = module.security_group_sub1.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

module "security_group_1_rule_2" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = module.security_group_sub1.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

module "security_group_bastion" {
  source = "../../modules/security_group"
  sg_description = "Bastion Security Group"
  vpc_id = module.VPC.vpc_id
  name = "bastion-sg"
}

module "bastion_sg_rule_1" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.security_group_bastion.security_group_id
  cidr_blocks = ["98.25.199.67/32"]
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
  az_id = module.availability_zones.availability_zones[1]
}

module "security_group_sub2" {
  source = "../../modules/security_group"
  sg_description = "private-security-group"
  vpc_id = module.VPC.vpc_id
  name = "private-sg"
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

module "security_group_2_rule_2" {
  source = "../../modules/security_group_rule"
  source_sg = true
  type = "ingress"
  from_port = 22
  to_port = 22
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
  route_table_id = module.route_table_sub_2.route_table_id
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

module "ec2_bastion" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_1.subnet_id
  name = "My Bastion Host"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_bastion.security_group_id]
}

module "ec2_0" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_2.subnet_id
  name = "My WebServer Dev 1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_sub2.security_group_id]
}

module "ec2_1" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_2.subnet_id
  name = "My WebServer Dev 2"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_sub2.security_group_id]
}

module "ec2_2" {
  source = "../../modules/ec2/red_hat"
  subnet_id = module.subnet_2.subnet_id
  name = "My WebServer Dev 3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_sub2.security_group_id]
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
}

module "nat_gateway" {
  source = "../../modules/nat_gateway"
  name = "NAT Gateway Dev"
  eip_id = module.elastic_ip.eip_id
  subnet_id = module.subnet_1.subnet_id
}

module "load_balancer_target_group" {
  source = "../../modules/lb_target_group"
  name = "api-webserver-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = module.VPC.vpc_id
  target_type = "instance"
  lb_algorithm = "round_robin"
}

module "lb_target_group_attachment_0" {
  source = "../../modules/lb_target_attachment"
  target_group_arn = module.load_balancer_target_group.target_group_arn
  target_id = module.ec2_0.instance_id
  port = 80
}

module "lb_target_group_attachment_1" {
  source = "../../modules/lb_target_attachment"
  target_group_arn = module.load_balancer_target_group.target_group_arn
  target_id = module.ec2_1.instance_id
  port = 80
}

module "lb_target_group_attachment_2" {
  source = "../../modules/lb_target_attachment"
  target_group_arn = module.load_balancer_target_group.target_group_arn
  target_id = module.ec2_2.instance_id
  port = 80
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

module "load_balancer_listener" {
  source = "../../modules/lb_listener"
  load_balancer_arn = module.load_balancer.load_balancer_arn
  port = 80
  protocol = "HTTP"
  target_group_arn = module.load_balancer_target_group.target_group_arn
}