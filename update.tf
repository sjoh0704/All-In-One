# kubeconfig를 업데이트 
resource "null_resource" "update-kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.AWS_DEFAULT_REGION} update-kubeconfig --name ${var.aws_cluster_name}"
  }
  
    lifecycle {
    create_before_destroy = true
  }
  
    depends_on = [
    aws_eks_node_group.eks-node-group,
  ]
}

# vpc cni를 prefix-delegated로 변경
resource "null_resource" "update-vpc-cni-prfix-delegated" {
  provisioner "local-exec" {
    command = "kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true"
  }
  
    depends_on = [
    aws_eks_node_group.eks-node-group,
    null_resource.update-kubeconfig,
    module.eks-add-on.addon_dependencies
  ]
}