variable "vpc_name" {
  type = string
  description = "VPC name"
}
variable "cidr_block" {
  type = string
  description = "VPC CIDR block"
  validation {
    condition = can(regex("\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}", var.cidr_block))
    error_message = "Not a valid CIDR block. It should be #.#.#.#/<# greater than 16>."
  }
}
