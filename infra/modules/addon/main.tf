
resource "aws_eks_addon" "vpc_cni" {
  # count = var.addon_create_vpc_cni ? 1 : 0

  cluster_name      = var.aws_cluster_name
  addon_name        = "vpc-cni"
  resolve_conflicts = "OVERWRITE"
  # addon_version     = var.addon_vpc_cni_version

  # tags = local.tags
}

# resource "aws_eks_addon" "kube_proxy" {
#   count = var.addon_create_kube_proxy ? 1 : 0

#   cluster_name      = module.eks.cluster_id
#   addon_name        = "kube-proxy"
#   resolve_conflicts = "OVERWRITE"
#   addon_version     = var.addon_kube_proxy_version

#   tags = local.tags
# }

# resource "aws_eks_addon" "coredns" {
#   count = var.addon_create_coredns ? 1 : 0

#   cluster_name      = module.eks.cluster_id
#   addon_name        = "coredns"
#   resolve_conflicts = "OVERWRITE"
#   addon_version     = var.addon_coredns_version

#   tags = local.tags
# }