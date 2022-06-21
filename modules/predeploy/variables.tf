variable aws_cluster_name {
  description = "Name of AWS Cluster"
}

# aws-load-balancer-controller
variable eks_aws_load_balancer_controller_iam_role_arn {
  type = string
}

# aws-cloudwatch-metrics
variable eks_aws_cloudwatch_metrics_iam_role_arn {
  type = string
}
