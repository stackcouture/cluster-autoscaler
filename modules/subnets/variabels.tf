variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cluster-name" {
  type        = string
  description = "Cluster Name"
}

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "pub-subnet-count" {}
variable "pub-cidr-block" {
  type = list(string)
}
variable "pub-availability-zone" {
  type = list(string)
}
variable "pub-sub-name" {}

variable "pri-subnet-count" {}
variable "pri-cidr-block" {
  type = list(string)
}
variable "pri-availability-zone" {
  type = list(string)
}
variable "pri-sub-name" {}