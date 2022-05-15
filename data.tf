# EC2 image
data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220207.1-x86_64-gp2"]
  }

   owners =["137112412989"]
}

# AZ
data aws_availability_zones available {}

# My Location
data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# get ECR service
# data "aws_vpc_endpoint_service" "ecr_dkr" {
#   service_type = "Interface"
#   filter {
#     name   = "service-name"
#     values = ["*ecr.dkr*"]
#   }
# }

# oidc 
data "tls_certificate" "tls-certicate" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

