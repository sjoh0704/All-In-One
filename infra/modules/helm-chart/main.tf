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
  chart = "argo-cd"
  name = "argo-cd"
  namespace = "argo"
  create_namespace = true
  values = [
    "${file(var.argocd_values_path)}"
  ]
}

resource "helm_release" "msa-chart" {
  name       = "my-msa-chart"
  chart      = "../../../msa-shop"
  create_namespace = true
}
