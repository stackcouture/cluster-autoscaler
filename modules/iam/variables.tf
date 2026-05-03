variable "is_eks_role_enabled" {
  type        = bool
  description = "EKS Role enabled"
}

variable "is_eks_nodegroup_role_enabled" {
  type        = bool
  description = "EKS NodeGroup Role enabled"
}

variable "cluster-name" {
  type        = string
  description = "Cluster Name"
}

variable "aws_region" {
  type        = string
  description = "AWS Region Name"
}