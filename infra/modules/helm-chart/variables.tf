variable "aws_cluster_name" {
  description = "Name of AWS Cluster"
  type = string
}

variable cluster_endpoint {
  type = string
}

variable cluster_ca_cert {
  type = string
}

variable ingress_values_path {
  type = string
}

variable argocd_values_path {
  type = string
}