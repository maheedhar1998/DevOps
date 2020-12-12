variable "instance_id" {
  type =  string
  description = "ID of the instance to attach"
}
variable "network_interface_id" {
  type = string
  description = "ID of the network interface to attach to"
}
variable "device_index" {
  type = number
  description = "Number of the instance attached"
}