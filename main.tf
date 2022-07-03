# VPC
module "aws-vpc" {
  source = "./modules/vpc"
  aws_cluster_name = var.aws_cluster_name
  aws_vpc_cidr_block = var.aws_vpc_cidr_block
  aws_avail_zones = data.aws_availability_zones.available.names
  aws_cidr_subnets_public = var.aws_cidr_subnets_public
  aws_cidr_subnets_private = var.aws_cidr_subnets_private
  default_tags = var.default_tags
}

# IAM
module "aws-iam" {
  aws_iam_openid_connect_provider_url = aws_iam_openid_connect_provider.oidc.url
  aws_iam_openid_connect_provider_arn = aws_iam_openid_connect_provider.oidc.arn
  source = "./modules/iam"
}

# SG 
module "aws-security-group" {
  source = "./modules/security-group"
  aws_cluster_name = var.aws_cluster_name
  aws_vpc_id = module.aws-vpc.aws_vpc_id
  default_tags = var.default_tags
  workstation-external-cidr= "${chomp(data.http.workstation-external-ip.body)}/32"
}

# EKS controlplane
resource "aws_eks_cluster" "eks-cluster" {
  name = var.aws_cluster_name
  role_arn = module.aws-iam.eks_cluster_iam_role_arn
  version = var.cluster_version

  enabled_cluster_log_types = var.cluster_log_types
  
  vpc_config {
    security_group_ids = [module.aws-security-group.eks_controlplane_security_group_id] # cluster SG 설정
    subnet_ids = concat(module.aws-vpc.aws_subnet_ids_public, module.aws-vpc.aws_subnet_ids_private) ## public에도 있어야 public outbound LB 생성 가능 
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    module.aws-iam.eks_cluster_iam_role_policy_attachment_dependencies
    ]
}

# EKS node 
resource "aws_eks_node_group" "eks-node-group" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-${join("-", split(".", var.aws_instance_type[0]))}"
  node_role_arn = module.aws-iam.eks_node_iam_role_arn
  subnet_ids = module.aws-vpc.aws_subnet_ids_private
  capacity_type = var.spot_instance ? "SPOT":"ON_DEMAND"
  instance_types = var.aws_instance_type
  disk_size = var.aws_instance_disk_size

  labels = {
    "role" = "eks-${join("-", split(".", var.aws_instance_type[0]))}"
  }

  remote_access {
    ec2_ssh_key = var.AWS_SSH_KEY_NAME
  }

  scaling_config {
    desired_size = var.aws_eks_instance_size.desired
    min_size = var.aws_eks_instance_size.min
    max_size = var.aws_eks_instance_size.max
  }

  depends_on = [
    module.aws-iam.eks_node_iam_role_policy_attachment_dependencies
  ]

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.aws_cluster_name}-${join("-", split(".", var.aws_instance_type[0]))}-Node"
  }))
    
}

# Bastion 
resource "aws_instance" "bastion" {
  ami = data.aws_ami.distro.id
  instance_type = var.aws_bastion_size
  count = var.aws_bastion_num
  associate_public_ip_address = true
  subnet_id = element(module.aws-vpc.aws_subnet_ids_public, count.index)
  vpc_security_group_ids = [module.aws-security-group.bastion_security_group_id]
  key_name = var.AWS_SSH_KEY_NAME

  tags = merge(var.default_tags, tomap({
    "Name" = "${var.aws_cluster_name}-bastion"
  }))
}

# Addon
module "eks-add-on" {
  source = "./modules/addon"
  aws_cluster_name = var.aws_cluster_name
  default_tags = var.default_tags
  vpc_cni_service_account_role_arn = module.aws-iam.eks_vpc_cni_iam_role_arn

  depends_on = [
  # aws_eks_node_group.eks-node-group,
  module.aws-iam.addon_iam_role_policy_attachment_dependencies
  ]
}

# OIDC
resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls-certicate.certificates[0].sha1_fingerprint]
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

module "predeploy" {
  source = "./modules/predeploy"
  aws_cluster_name = var.aws_cluster_name
  
  # alb controller
  eks_aws_load_balancer_controller_iam_role_arn = module.aws-iam.eks_aws_load_balancer_controller_iam_role_arn
  
  # aws-cloudwatch-metrics controller
  eks_aws_cloudwatch_metrics_iam_role_arn = module.aws-iam.eks_aws_cloudwatch_metrics_iam_role_arn
  
  depends_on = [
  aws_eks_node_group.eks-node-group,
  ]
}


# vpc endpoint
# resource "aws_vpc_endpoint" "ecr_registry" {
#   vpc_id            = module.aws-vpc.aws_vpc_id
#   service_name      = data.aws_vpc_endpoint_service.ecr_dkr.service_name
#   vpc_endpoint_type = "Interface"

#   security_group_ids  = [module.aws-security-group.vpc_endpoint_ecr_security_group_id]
#   subnet_ids          = module.aws-vpc.aws_subnet_ids_private
#   private_dns_enabled = true

#   tags = {
#     Name        = "${var.aws_cluster_name}-ecr-endpoint"
#   }
# }