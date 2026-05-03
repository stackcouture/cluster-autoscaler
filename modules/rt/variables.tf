variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "igw_id" {
  type        = string
  description = "IGW ID"
}

# Route tables 

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "public-rt-name" {
  type        = string
  description = "Public Route Table Name"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string) # A list of strings (subnet IDs)
}

variable "nat_gateway_id" {
  type        = string
  description = "NGW ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of Private Subnet IDs"
}

variable "private-rt-name" {
  type        = string
  description = "Private Route Table Name"
}