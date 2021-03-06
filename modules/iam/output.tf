# control plane iam role
output eks_cluster_iam_role_arn {
    value = aws_iam_role.eks-cluster.arn
}

output eks_cluster_iam_role_policy_attachment_dependencies {
    value = {}
    depends_on = [
        aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController
    ]
}

# node iam role
output eks_node_iam_role_arn {
    value = aws_iam_role.eks-node.arn
}

output eks_node_iam_role_policy_attachment_dependencies {
    value = {}
    depends_on = [
        aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly
    ]
}

# oidc - vpc cni iam role
output eks_vpc_cni_iam_role_arn {
    value = aws_iam_role.vpc-cni.arn
}

output addon_iam_role_policy_attachment_dependencies {
    value = {}
    depends_on = [
        aws_iam_role_policy_attachment.vpc-cni-policy,
    ]
}

# oidc - aws-load-balancer-controller
output eks_aws_load_balancer_controller_iam_role_arn {
    value = aws_iam_role.aws-load-balancer-controller.arn
}


# oidc - aws-cloudwatch-metrics
output eks_aws_cloudwatch_metrics_iam_role_arn {
    value = aws_iam_role.aws-cloudwatch-metrics.arn
}
