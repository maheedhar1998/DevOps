data "aws_ami" "Red_Hat" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
   filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "red_hat_instance" {
  count = var.number_of_instances
  ami = data.aws_ami.Red_Hat.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name = var.key_name
  iam_instance_profile = var.iam_instance_profile
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name = "${var.name}-${count.index+1}"
  }
}