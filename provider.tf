terraform {
  required_version = ">= 1.1.9"

   required_providers {
    aws = {
      version = ">= 4.8.0"
      source = "hashicorp/aws"
    }
  }

}

provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_DEFAULT_REGION
}


provider "kubernetes" {
  host = aws_eks_cluster.eks-cluster.endpoint 
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.aws_cluster_name]
    command     = "aws"
  }
}


provider "helm" {
  kubernetes {
    host = aws_eks_cluster.eks-cluster.endpoint 
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.aws_cluster_name]
      command     = "aws"
    }
  }
}