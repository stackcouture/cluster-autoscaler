variable "private_subnet_ids" {
  type        = list(string)
  description = "List of Private Subnet IDs"
}

variable "aws_eks_security_group_id" {
  type        = string
  description = "Security Group IDs"
}

variable "is-eks-cluster-enabled" {
  type        = bool
  description = "EKS Cluster Enabled"
}

variable "cluster-name" {
  type        = string
  description = "Cluster name"
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

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "eks-cluster-role-arn" {
  type        = string
  description = "EKS Cluster Role ARN"
}

variable "node_eks_role_arn" {
  type        = string
  description = "EKS NodeGroup Role ARN"
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