variable "subnet_cidr_block" {
  type = string
  description = "subnet CIDR block"
  validation {
    condition = can(regex("\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}", var.subnet_cidr_block))
    error_message = "Not a valid CIDR block. It should be #.#.#.#/<# greater than 16>."
  }
}