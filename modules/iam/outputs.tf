output "eks-cluster-role-arn" {
  value = aws_iam_role.eks-cluster-role[0].arn
}

output "eks-nodegroup-role-arn" {
  value = aws_iam_role.eks-nodegroup-role[0].arn
}