output eks_cluster_iam_role_arn {
    value = aws_iam_role.eks-cluster.arn
}

output eks_node_iam_role_arn {
    value = aws_iam_role.eks-node.arn
}

output eks_cluster_iam_role_policy_attachment_dependencies {
    value = {}
    depends_on = [
        aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController
    ]
}

output eks_node_iam_role_policy_attachment_dependencies {
    value = {}
    depends_on = [
        aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly
    ]
}