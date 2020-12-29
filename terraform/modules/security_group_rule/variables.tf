variable "type" {
  type = string
  description = "The Type of Security Group Rule"
}
variable "from_port" {
  type = number
  description = "The From Port for the Security Group Rule"
}
variable "to_port" {
  type = number
  description = "The To Port for the Security Group Rule"
}
variable "protocol" {
  type = string
  description = "The Protocol to Use for the Security Rule"
}
variable "security_group_id" {
  type = string
  description = "The ID for the Security Group to associate the rule with"
}
variable "source_sg_id" {
  type = string
  description = "The ID of the Source Security Group"
  default = ""
}
variable "source_sg" {
  type = bool
  description = "Whether the source is Security Group or a CIDR block"
}
variable "source_self" {
  type = bool
  description = "Whether the source is the self security group or not"
  default = false
}
variable "cidr_blocks" {
  type = list(string)
  description = "A List of Source IPv4 CIDR Blocks"
  default = []
}
variable "ipv6_cidr_blocks" {
  type = list(string)
  description = "A list of Source IPv6 CIDR Blocks"
  default = []
}