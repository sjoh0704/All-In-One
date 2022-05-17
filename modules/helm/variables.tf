variable aws_cluster_name {
  description = "Name of AWS Cluster"
}
# argo-cd 
variable argocd_values_path {
  type = string
}

# aws-load-balancer-controller
variable aws_load_balancer_controller_values_path {
  type = string
}

variable eks_aws_load_balancer_controller_iam_role_arn {
  type = string
}

# aws-cloudwatch-metrics
variable aws_cloudwatch_metrics_values_path {
  type = string
}

variable eks_aws_cloudwatch_metrics_iam_role_arn {
  type = string
}
