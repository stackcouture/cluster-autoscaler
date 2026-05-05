data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks[0].identity[0].oidc[0].issuer
}

output "cluster_url" {
  value = aws_eks_cluster.eks[0].identity[0].oidc[0].issuer
}

output "thumbprint_list" {
  value = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks-oidc.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks-oidc.url
}