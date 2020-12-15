variable "name" {
  type = string
  description = "Name of the target group"
}
variable "port" {
  type = number
  description = "The port on which targets receive traffic"
}
variable "protocol" {
  type = string
  description = "The protocol to use for routing traffic to the targets."
}
variable "vpc_id" {
  type = string
  description = "The identifier of the VPC in which to create the target group."
}
variable "target_type" {
  type = string
  description = "The type of target that you must specify when registering targets with this target group."
}
variable "lb_algorithm" {
  type = string
  description = "Load Balancing Algorithm Type"
}