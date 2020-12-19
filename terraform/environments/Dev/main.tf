terraform {
  backend "s3" {
    bucket = "terraform-state-files-maheedhar"
    key = "terraform_state/devOps_tutorial"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}

module "VPC" {
  source = "../../modules/vpc"
  vpc_name = "dev-VPC"
  cidr_block = "10.11.0.0/16"
}

module "availability_zones" {
  source = "../../modules/availability_zones"
}

module "subnet_1" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  subnet_cidr_block = "10.11.1.0/24"
  name = "public-subnet-dev"
  az_id = module.availability_zones.availability_zones[0]
  auto_public_ip = true
}

module "security_group_sub1" {
  source = "../../modules/security_group"
  sg_description = "public-dev-sg"
  vpc_id = module.VPC.vpc_id
  name = "public-dev-sg"
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

module "security_group_1_rule_3" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  security_group_id = module.security_group_sub1.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

module "security_group_bastion" {
  source = "../../modules/security_group"
  sg_description = "Bastion-dev-sg"
  vpc_id = module.VPC.vpc_id
  name = "bastion-dev-sg"
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

module "bastion_sg_rule_2" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  security_group_id = module.security_group_bastion.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

module "bastion_sg_rule_3" {
  source = "../../modules/security_group_rule"
  source_sg = true
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.security_group_bastion.security_group_id
  source_sg_id = module.security_group_sub2.security_group_id
}

module "route_table_sub_1" {
  source = "../../modules/route_table"
  name = "public-route-table"
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
  name = "webserver-subnet-dev"
  az_id = module.availability_zones.availability_zones[1]
  auto_public_ip = false
}

module "security_group_sub2" {
  source = "../../modules/security_group"
  sg_description = "webserver-dev-sg"
  vpc_id = module.VPC.vpc_id
  name = "webserver-dev-sg"
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

module "security_group_2_rule_3" {
  source = "../../modules/security_group_rule"
  source_sg = false
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  security_group_id = module.security_group_sub2.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

module "security_group_2_rule_4" {
  source = "../../modules/security_group_rule"
  source_sg = true
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = module.security_group_sub2.security_group_id
  source_sg_id = module.security_group_bastion.security_group_id
}

module "security_group_2_rule_5" {
  source = "../../modules/security_group_rule"
  source_sg = true
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.security_group_sub2.security_group_id
  source_sg_id = module.security_group_bastion.security_group_id
}

module "route_table_sub_2" {
  source = "../../modules/route_table"
  name = "webserver-route-table"
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

module "key_pair" {
  source = "../../modules/key_pair"
  name = "my-ssh-key"
  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9dwsDLDLf5SpLt7CG+F/pS0OCkgk9AjTJnKMba5LWrXb4cqyL+cjeuds/vOhr6Vhw9BIt3GEb1rFP5eOkUZTqSwxEyirm5beEtyRutciuUGuDAKLogAAD6frX40YHNezCyCgViV4XSIG42YjmZBhajzZM19XcaqFTSYigXMKKiZJ0jnd7Iad03u+Abr6Ijd9ygXTTkuB3zly+hvIQGppnkC1eZ7whaPr6AD22WYhbFQ+knPtzWPBpTALgKBCnwcTN8MsnWVxT/SIX84uzQO0z4ZBgewwKtdCtscS6nNWsyLlONEGSakLcAtCz9bjfNLVLa6en3TsOacCg4o3uAsFDLcqvOhWKMMocED2cdrYWhlp9aHq/Z1sCG4pcjC79e1lged0WjnycVggrJ1BcZqh+AW9DA2s+1i4T+oyEdoJbPc/n0mpg1d99qinKlYU+xijJXesHadNPxqF0eoH4SiJJoPGGDKhUJkYzKqCESYp+B5rBhUi4aFSDikkXTv9zqec= maheedhar@maheedhars-ryzen-ripper-linux"
}

module "ec2_bastion" {
  source = "../../modules/ec2/red_hat"
  number_of_instances = 1
  subnet_id = module.subnet_1.subnet_id
  name = "bastion-host-dev"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_bastion.security_group_id]
  key_name = "my-ssh-key"
}

module "iam_ec2_to_s3_access_policy" {
  source = "../../modules/iam_policy"
  name = "ec2_to_s3_access"
  description = "Gives EC2 acess to S3 Buckets"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
  EOF
}

module "iam_ec2_to_s3_access_role" {
  source = "../../modules/iam_role"
  name = "ec2_to_s3_access"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

module "iam_ec2_to_s3_policy_attach" {
  source = "../../modules/iam_role_policy_attachment"
  role = module.iam_ec2_to_s3_access_role.name
  policy_arn = module.iam_ec2_to_s3_access_policy.policy_arn
}

module "iam_ec2_webserver_instance_profile" {
  source = "../../modules/iam_instance_profile"
  name = "webserver-dev-role-attach"
  role = module.iam_ec2_to_s3_access_role.name
}

module "ec2_webserver" {
  source = "../../modules/ec2/red_hat"
  number_of_instances = 3
  subnet_id = module.subnet_2.subnet_id
  name = "webserver-dev"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_sub2.security_group_id]
  key_name = "my-ssh-key"
  iam_instance_profile = module.iam_ec2_webserver_instance_profile.name
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
  name = "nat-gateway-elastic-ip"
}

module "nat_gateway" {
  source = "../../modules/nat_gateway"
  name = "nat-gateway-dev"
  eip_id = module.elastic_ip.eip_id
  subnet_id = module.subnet_1.subnet_id
}

module "load_balancer_target_group" {
  source = "../../modules/lb_target_group"
  name = "api-webserver-target-group"
  port = 80
  protocol = "HTTP"
  health_check_protocol = "HTTP"
  vpc_id = module.VPC.vpc_id
  target_type = "instance"
  lb_algorithm = "round_robin"
}

module "lb_target_group_attachment" {
  source = "../../modules/lb_target_attachment"
  target_group_arn = module.load_balancer_target_group.target_group_arn
  target_ids = module.ec2_webserver.instance_ids
  port = 80
}

module "load_balancer" {
  source = "../../modules/load_balancer"
  name = "apllication-load-balancer-dev"
  internal = false
  lb_type = "application"
  subnets = [module.subnet_1.subnet_id, module.subnet_2.subnet_id]
  security_groups = [module.security_group_sub1.security_group_id]
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
