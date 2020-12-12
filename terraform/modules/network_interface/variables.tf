variable "name" {
  type = string
  description = "Name of the Network Interface (Elastic)"
}
variable "subnet_id" {
  type = string
  description = "Subnet ID that the network interface resides in"
}
variable "private_ips" {
  type = list(string)
  description = "List of Private IP addresses to assign to the ENI"
}
variable "security_groups" {
  type = list(string)
  description = "List of Security Groups to associate the ENI with"
}