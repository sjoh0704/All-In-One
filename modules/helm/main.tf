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

resource "helm_release" "prometheus" {
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  name = "argo-cd"
  namespace = "argo"
  create_namespace = true
  values = [
    "${file(var.argocd_values_path)}"
  ]
}
# resource "helm_release" "grafana" {
#   repository = "https://argoproj.github.io/argo-helm"
#   chart = "argo-cd"
#   name = "argo-cd"
#   namespace = "argo"
#   create_namespace = true
#   values = [
#     "${file(var.argocd_values_path)}"
#   ]
# }

# resource "helm_release" "alb-controller" {
#   repository = "https://argoproj.github.io/argo-helm"
#   chart = "argo-cd"
#   name = "argo-cd"
#   namespace = "argo"
#   create_namespace = true
#   values = [
#     "${file(var.argocd_values_path)}"
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
