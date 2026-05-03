# VPC Variables 

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "instance_tenancy" {
  type        = string
  description = "VPC Instance Tenancy"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS Support"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS Hostnam"
}

# IGW 
variable "igw_name" {
  type        = string
  description = "Internet Gateway Name"
}

variable "cluster-name" {
  type        = string
  description = "Cluster Name"
}

# Subnets 
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

# Route tables 
variable "public-rt-name" {
  type        = string
  description = "Public Route Table Name"
}

# NAT Gateway 
variable "nat_gw_name" {
  type        = string
  description = "NAT Gateway Name"
}

variable "eip_name" {
  type        = string
  description = "Elastic IP Name"
}

variable "private-rt-name" {
  type        = string
  description = "Private Route Table Name"
}

# Security Group 
variable "sg_name" {
  type        = string
  description = "Security Group Name"
}

variable "sg_description" {
  type        = string
  description = "Security Group Desription"
}

# IAM Role Varibales 
variable "is_eks_role_enabled" {
  type        = bool
  description = "EKS Role enabled"
}

variable "is_eks_nodegroup_role_enabled" {
  type        = bool
  description = "EKS NodeGroup Role enabled"
}

variable "aws_region" {
  type        = string
  description = "AWS Region Name"
}

# Cluster Variables 
variable "is-eks-cluster-enabled" {
  type        = bool
  description = "EKS Cluster Enabled"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "endpoint-private-access" {
  type        = string
  description = "Cluster EndPoint Private Access"
}

variable "endpoint-public-access" {
  type        = string
  description = "Cluster EndPoint Public Access"
}

variable "desired_capacity" {
  type        = string
  description = "Desired Capacity"
}

variable "min_capacity" {
  type        = string
  description = "Minimum Capacity"
}

variable "max_capacity" {
  type        = string
  description = "Maximum capacity"
}

variable "instance_types" {
  type        = list(string)
  description = "Instance Types"
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}