variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "nat_gw_name" {
  type        = string
  description = "NAT Gateway Name"
}

variable "eip_name" {
  type        = string
  description = "Elastic IP Name"
}

variable "igw_id" {
  type        = string
  description = "IGW"
}

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}