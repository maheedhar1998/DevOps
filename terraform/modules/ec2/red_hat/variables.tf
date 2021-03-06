variable "subnet_id" {
    type = string
    description = "Subnet ID to associate the instance with"
}
variable "name" {
    type = string
    description = "Instance name"
}
variable "instance_type" {
    type =  string
    description = "Type of ec2 instance"
}
variable "vpc_security_group_ids" {
    type = list(string)
    description = "Security Groups in VPC to associate the EC2 instances with"
}
variable "key_name" {
    type = string
    description = "Name of the Key Pair"
}
variable "number_of_instances" {
    type = number
    description = "Number of instances to initialize"
}
variable "iam_instance_profile" {
    type = string
    description = "Name of the Instance Profile"
    default = ""
}