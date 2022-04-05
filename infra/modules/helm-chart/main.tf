provider "kubernetes" {
  host = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.aws_cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.aws_cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "nginx-ingress" {

  repository = "https://charts.bitnami.com/bitnami"
  chart = "nginx-ingress-controller"
  name = "nginx-ingress-controller"
  namespace = "nginx-ingress"
  create_namespace = true
  values = [
    "${file(var.ingress_values_path)}"
  ]
}

resource "helm_release" "argo-cd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo"
  name = "argo-cd"
  namespace = "argo"
  create_namespace = true
  values = [
    "${file(var.argocd_values_path)}"
  ]
}

## TODO Applicatio crd 없음
resource "helm_release" "msa-chart" {
  name       = "my-msa-chart"
  chart      = "../../../msa-shop"
  create_namespace = true
}
