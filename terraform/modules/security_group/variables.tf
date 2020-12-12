variable "name" {
  type = string
  description = "Security Group Name"
}
variable "description" {
  type = string
  description = "The Description of the Security Group"
}
variable "vpc_id" {
  type = string
  description = "ID of the VPC that the Security Group Resides in"
}