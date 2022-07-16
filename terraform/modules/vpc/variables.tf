variable "vpc_name" {
  default     = ""
  description = "Name for vpc"
  type        = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0"
  description = "CRID for vpc"
}

variable "private_subnets" {
  type        = map(any)
  description = "Private subnets to be created"
}

variable "public_subnets" {
  type        = map(any)
  description = "Public subnets to be created"
}