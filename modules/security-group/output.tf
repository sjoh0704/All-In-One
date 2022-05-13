output eks_controlplane_security_group_id {
    value = aws_security_group.eks-controlplane.id
}

output bastion_security_group_id {
    value = aws_security_group.bastion.id
}

output vpc_endpoint_ecr_security_group_id {
    value = aws_security_group.vpc-endpoint-ecr.id
}


