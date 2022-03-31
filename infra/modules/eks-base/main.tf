module "aws-vpc" {
  source = "../vpc"

  aws_cluster_name         = var.aws_cluster_name
  aws_vpc_cidr_block       = var.aws_vpc_cidr_block
  aws_avail_zones          = data.aws_availability_zones.available.names
  aws_cidr_subnets_public  = var.aws_cidr_subnets_public
  aws_cidr_subnets_private = var.aws_cidr_subnets_private
  default_tags             = var.default_tags
}

module "aws-iam" {
  source                   = "../iam"
}

module "aws-security-group" {
  source                   = "../security-group"
  aws_vpc_id               = module.aws-vpc.aws_vpc_id
  default_tags             = var.default_tags
  workstation-external-cidr= local.workstation-external-cidr
}


resource "aws_eks_cluster" "eks-cluster" {
  name     = var.aws_cluster_name
  role_arn = module.aws-iam.eks_cluster_iam_role_arn
  version = "1.20"

  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    security_group_ids = [module.aws-security-group.eks_cluster_security_group_id]
    subnet_ids         = concat(module.aws-vpc.aws_subnet_ids_public, module.aws-vpc.aws_subnet_ids_private)
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    module.aws-iam.eks_cluster_iam_role_policy_attachment_dependencies
    ]
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-t2-medium"
  node_role_arn   = module.aws-iam.eks_node_iam_role_arn
  subnet_ids      = module.aws-vpc.aws_subnet_ids_private
  instance_types = [var.aws_instance_type]
  disk_size = var.aws_instance_disk_size

  labels = {
    "role" = "eks-${var.aws_instance_type}"
  }

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 3
  }

  depends_on = [
    module.aws-iam.eks_node_iam_role_policy_attachment_dependencies
  ]

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.aws_cluster_name}-eks-${var.aws_instance_type}-Node"
  }))
}