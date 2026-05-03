variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cluster-name" {
  type        = string
  description = "Cluster name"
}

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "sg_name" {
  type        = string
  description = "Security Group Name"
}

variable "sg_description" {
  type        = string
  description = "Security Group Desription"
}