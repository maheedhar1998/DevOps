variable "name" {
    type = string
    description = "Name of the Load Balancer"
}
variable "internal" {
    type = bool
    description = "Whether or not Load Balancer is internal"
}
variable "lb_type" {
    type = string
    description = "Type of Load Balancer"
}
variable "subnets" {
    type = list(string)
    description = "List of subnets associated with the Load Balancer"
}
variable "security_groups" {
    type = list(string)
    description = "List of security groups to associate the load balancer with"
}
variable "log_bucket" {
    type = string
    description = "Bucket ID of the Logs Bucket for the Load Balancer"
}
variable "s3_prefix" {
    type = string
    description = "Prefix of Logs"
}