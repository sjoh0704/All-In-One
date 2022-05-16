# resource "helm_release" "nginx-ingress" {

#   count = var.ingress_values_path ? 1:0
#   repository = "https://charts.bitnami.com/bitnami"
#   chart = "nginx-ingress-controller"
#   name = "nginx-ingress-controller"
#   namespace = "nginx-ingress"
#   create_namespace = true
#   values = [
#     "${file(var.ingress_values_path)}"
#   ]
# }

# argo-cd set up
resource "helm_release" "argo-cd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  name = var.aws_cluster_name
  namespace = "argo-cd"
  create_namespace = true
  values = [
    "${file(var.argocd_values_path)}"
  ]
}

# aws-lb-controller set up 
resource "helm_release" "aws-lb-controller" {
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"
  name = var.aws_cluster_name
  namespace = "kube-system"
  create_namespace = true
  values = [
    "${file(var.aws_load_balancer_controller_values_path)}"
  ]
  depends_on = [
    kubernetes_service_account.aws-lb-controller
  ]
}

resource "kubernetes_service_account" "aws-lb-controller" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = var.eks_aws_load_balancer_controller_iam_role_arn
    }
  }
  automount_service_account_token = true
}


# # aws-cloudwatch-metrics set up # 클러스터 지표 수집 
# resource "helm_release" "aws-cloudwatch-metrics" {
#   repository = "https://aws.github.io/eks-charts"
#   chart = "aws-cloudwatch-metrics"
#   name = var.aws_cluster_name
#   namespace = "amazon-cloudwatch"
#   create_namespace = true
#   # values = [
#   #   "${file(var.aws_load_balancer_controller_values_path)}"
#   # ]
# }



# resource "helm_release" "msa-chart" {
#   name       = "msa-chart"
#   chart      = "../msa-shop"
#   create_namespace = true

#   lifecycle {
#     create_before_destroy = true
#   }

#     depends_on = [
#       helm_release.argo-cd
#   ]
# }
