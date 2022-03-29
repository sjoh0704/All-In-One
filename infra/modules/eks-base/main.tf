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
  aws_vpc_id               = module.aws-vpc.aws_vpc_id
  default_tags             = var.default_tags
  workstation-external-cidr= local.workstation-external-cidr
}

