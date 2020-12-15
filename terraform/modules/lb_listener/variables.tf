variable "load_balancer_arn" {
  type = string
  description = "ARN of Load Balancer to attach to"
}
variable "port" {
  type = number
  description = "Port to listen on"
}
variable "protocol" {
  type = string
  description = "Protocol for connections from clients to the load balancer"
}
variable "target_group_arn" {
  type = string
  description = "ARN of the target group to froward the request to"
}