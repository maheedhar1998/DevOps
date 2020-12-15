variable "target_group_arn" {
  type = string
  description = "The ARN of the target group with which to register targets"
}
variable "target_id" {
  type = string
  description = "The ID of the Target"
}
variable "port" {
  type = number
  description = "The port on which targets receive traffic"
}