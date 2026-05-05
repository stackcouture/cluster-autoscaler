resource "aws_eks_cluster" "eks" {

  count    = var.is-eks-cluster-enabled == true ? 1 : 0
  name     = var.cluster-name
  role_arn = var.eks-cluster-role-arn # aws_iam_role.eks-cluster-role[count.index].arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = var.endpoint-private-access
    endpoint_public_access  = var.endpoint-public-access
    security_group_ids      = [var.aws_eks_security_group_id] #[aws_security_group.eks-cluster-sg.id]
  }


  access_config {
    authentication_mode                         = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = var.cluster-name
    Env  = var.env
  }
}

# OpenID connect
data "tls_certificate" "eks-certificate" {
  url = aws_eks_cluster.eks[0].identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks-oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-certificate.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks-certificate.url
}

data "aws_iam_policy_document" "eks_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-test"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks-oidc.arn]
      type        = "Federated"
    }
  }
}

data "aws_eks_addon_version" "this" {
  for_each = toset([
    "vpc-cni",
    "coredns",
    "kube-proxy",
  ])
  addon_name         = each.value
  kubernetes_version = aws_eks_cluster.eks[0].version
  most_recent        = true
}

resource "aws_eks_addon" "addons" {
  for_each      = data.aws_eks_addon_version.this
  cluster_name  = aws_eks_cluster.eks[0].name
  addon_name    = each.key
  addon_version = each.value.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = each.key == "vpc-cni" ? jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
      WARM_PREFIX_TARGET       = "1"
    }
  }) : null


  depends_on = [aws_eks_node_group.ondemand-node]
}

resource "aws_eks_node_group" "ondemand-node" {
  cluster_name    = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster-name}-ondemand-node-group"
  node_role_arn   = var.node_eks_role_arn # aws_iam_role.eks_nodegroup_role[0].arn
  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    min_size     = var.min_capacity
    max_size     = var.max_capacity
  }

  instance_types = var.instance_types
  capacity_type  = "ON_DEMAND"

  labels = {
    type = "on-demand"
  }

  update_config {
    max_unavailable = 1
  }


  tags = {
    "Name"                                          = "${var.cluster-name}-ondemand-nodes"
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${var.cluster-name}" = "owned"
  }

  tags_all = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }

  depends_on = [aws_eks_cluster.eks]
}

# resource "aws_eks_node_group" "spot-node" {
#   cluster_name    = aws_eks_cluster.eks[0].name
#   node_group_name = "${var.cluster-name}-spot-node-group"
#   node_role_arn   = var.node_eks_role_arn

#   subnet_ids = var.private_subnet_ids

#   scaling_config {
#     desired_size = 0
#     min_size     = 0
#     max_size     = 10
#   }

#   instance_types = [
#     "t3.large",
#     "t3a.large",
#     "m5.large",
#     "m5a.large"
#   ]

#   capacity_type = "SPOT"

#   labels = {
#     type = "spot"
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   tags = {
#     Name = "${var.cluster-name}-spot-nodes"

#     "k8s.io/cluster-autoscaler/enabled"             = "true"
#     "k8s.io/cluster-autoscaler/${var.cluster-name}" = "owned"
#   }

#   depends_on = [aws_eks_cluster.eks]
# }