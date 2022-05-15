resource "aws_eks_addon" "kube-proxy-addon" {
  cluster_name      = var.aws_cluster_name
  addon_name        = "kube-proxy"
  addon_version     = "v1.21.2-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
  tags = var.default_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_addon" "coredns-addon" {
  cluster_name      = var.aws_cluster_name
  addon_name        = "coredns"
  addon_version     = "v1.8.4-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  tags = var.default_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_addon" "vpc-cni-addon" {
  cluster_name      = var.aws_cluster_name
  addon_name        = "vpc-cni"
  addon_version     = "v1.10.1-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  service_account_role_arn = var.vpc_cni_service_account_role_arn
  tags = var.default_tags

  lifecycle {
    create_before_destroy = true
  }
}
