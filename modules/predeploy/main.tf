# argo-cd set up
# Argocd는 선배포 
resource "helm_release" "argo-cd" {
  chart      = "${abspath(path.root)}/chart/argo-cd"
  name = "argo"
  namespace = "argo"
  create_namespace = true
  
  // helm values file의 clusterName 변경이 필요한 경우  
  provisioner "local-exec" {
    command = "sed -i 's/^clusterName:.*$/clusterName: ${var.aws_cluster_name}/g' $CLOUD_WATCH_PATH;"

    environment = {
      CLOUD_WATCH_PATH = "${abspath(path.root)}/chart/aws-cloudwatch-metrics/values.yaml"
    }
  }

  provisioner "local-exec" {
    command = "sed -i 's/^clusterName:.*$/clusterName: ${var.aws_cluster_name}/g' $AWS_LB_CTR_PATH;"

    environment = {
      AWS_LB_CTR_PATH = "${abspath(path.root)}/chart/aws-load-balancer-controller/values.yaml"
    }
  }
}

# infra chart aplication 배포
resource "helm_release" "infra" {
  chart      = "${abspath(path.root)}/chart/infra"
  name = "infra"
  namespace = "argo"
  create_namespace = false
    depends_on = [
  helm_release.argo-cd
  ]
}

# msa chart aplication 배포
resource "helm_release" "msa-shop" {
  chart      = "${abspath(path.root)}/chart/msa-shop"
  name = "infra"
  namespace = "argo"
  create_namespace = false
    depends_on = [
  helm_release.argo-cd
  ]
}


# aws-lb-controller service account 
# 필요한 iam role을 갖는 SA를 미리 배포 
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

# amazon cloud watch service account
# 필요한 IAM Role을 갖는 SA를 미리 배포 
resource "kubernetes_namespace" "aws-cloudwatch-metrics" {
  metadata {
    name = "amazon-cloudwatch"
  }
}

resource "kubernetes_service_account" "aws-cloudwatch-metrics" {
  metadata {
    name = "aws-cloudwatch-metrics"
    namespace = "amazon-cloudwatch"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.eks_aws_cloudwatch_metrics_iam_role_arn
    }
  }
  automount_service_account_token = true
  depends_on = [
  kubernetes_namespace.aws-cloudwatch-metrics
  ]
}



# aws-lb-controller set up 
# resource "helm_release" "aws-lb-controller" {
#   repository = "https://aws.github.io/eks-charts"
#   chart = "aws-load-balancer-controller"
#   name = var.aws_cluster_name
#   namespace = "kube-system"
#   create_namespace = true
#   values = [
#     "${file(var.aws_load_balancer_controller_values_path)}"
#   ]
#   depends_on = [
#     kubernetes_service_account.aws-lb-controller
#   ]
# }

# # aws-cloudwatch-metrics set up # 클러스터 지표 수집 
# resource "helm_release" "aws-cloudwatch-metrics" {
#   repository = "https://aws.github.io/eks-charts"
#   chart = "aws-cloudwatch-metrics"
#   name = var.aws_cluster_name
#   namespace = "amazon-cloudwatch"
#   create_namespace = true
#   values = [
#     "${file(var.aws_cloudwatch_metrics_values_path)}"
#   ]
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