data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "Red_Hat" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.Red_Hat.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main.id
  tags = {
    Name = "Webserver"
  }
}