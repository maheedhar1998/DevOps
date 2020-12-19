variable "role" {
  type = string
  description = "The Role to attach the policy to"
}
variable "policy_arn" {
  type = string
  description = "ARN of the Policy to attach to the role"
}