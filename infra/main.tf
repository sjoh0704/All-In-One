module "aws-vpc" {
  source = "./modules/vpc"
  aws_cluster_name = var.aws_cluster_name
  aws_vpc_cidr_block = var.aws_vpc_cidr_block
  aws_avail_zones = data.aws_availability_zones.available.names
  aws_cidr_subnets_public = var.aws_cidr_subnets_public
  aws_cidr_subnets_private = var.aws_cidr_subnets_private
  default_tags = var.default_tags
}

module "aws-iam" {
  source = "./modules/iam"
}

module "aws-security-group" {
  source = "./modules/security-group"
  aws_cluster_name = var.aws_cluster_name
  aws_vpc_id = module.aws-vpc.aws_vpc_id
  default_tags = var.default_tags
  workstation-external-cidr= "${chomp(data.http.workstation-external-ip.body)}/32"
}


resource "aws_eks_cluster" "eks-cluster" {
  name = var.aws_cluster_name
  role_arn = module.aws-iam.eks_cluster_iam_role_arn
  version = var.cluster_version

  enabled_cluster_log_types = var.cluster_log_types

  vpc_config {
    security_group_ids = [module.aws-security-group.eks_cluster_security_group_id]
    subnet_ids = concat(module.aws-vpc.aws_subnet_ids_public, module.aws-vpc.aws_subnet_ids_private)
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    module.aws-iam.eks_cluster_iam_role_policy_attachment_dependencies
    ]
}

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
    # source_security_group_ids = [module.aws-security-group.eks_node_security_group_id]
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

## TODO: depend on 추가(첫번째 실행시 에러)
module "eks-add-on" {
  source = "./modules/addon"
  aws_cluster_name = var.aws_cluster_name
  default_tags = var.default_tags
  
  depends_on = [
  aws_eks_node_group.eks-node-group,
  aws_eks_cluster.eks-cluster
  ]
}


module "helm-chart" {
  source = "./modules/helm-chart"
  ingress_values_path = "./helm-values/ingress.yaml"
  argocd_values_path = "./helm-values/argocd.yaml"

  depends_on = [
  aws_eks_node_group.eks-node-group,
  aws_eks_cluster.eks-cluster
  ]
}


resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.AWS_DEFAULT_REGION} update-kubeconfig --name ${var.aws_cluster_name}"
  }
  
    lifecycle {
    create_before_destroy = true
  }
  
    depends_on = [
  aws_eks_node_group.eks-node-group,
  aws_eks_cluster.eks-cluster
  ]
}