variable "eip_id" {
  type = string
  description = "The ID of the Elastic IP address for the gateway"
}
variable "subnet_id" {
  type = string
  description = "Subnet ID that the NAT gateway reside in"
}
variable "name" {
  type = string
  description = "NAT gateway name"
}