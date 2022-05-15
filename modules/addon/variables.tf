variable "aws_cluster_name" {
  description = "Name of AWS Cluster"
  type = string
}


variable "default_tags" {
  description = "Default tags for all resources"
  type = map(string)
}

variable "vpc_cni_service_account_role_arn" {
  type = string
}
