output eks_cluster_security_group_id {
    value = aws_security_group.eks-cluster.id
}

output eks_node_security_group_id {
    value = aws_security_group.eks-node.id
}

output bastion_security_group_id {
    value = aws_security_group.bastion.id
}
