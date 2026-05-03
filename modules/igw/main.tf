locals {
  cluster-name = var.cluster-name
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name                                          = var.igw_name
    Env                                           = var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
  }
  depends_on = [var.vpc_id]
}