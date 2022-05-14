## EKS control plane SG 
resource "aws_security_group" "eks-controlplane" {
  name = "eks-controlplane"
  description = "Cluster communication with worker nodes"
  vpc_id = var.aws_vpc_id

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-eks-controlplane"
  }))
}

resource "aws_security_group_rule" "eks-controlplane-egress" {
  type = "egress" 
  cidr_blocks = ["0.0.0.0/0"]  # to
  to_port = 65535
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.eks-controlplane.id 
}

resource "aws_security_group_rule" "eks-controlplane-ingress" {
  type = "ingress"
  cidr_blocks = [var.workstation-external-cidr] # 나만 접근 가능
  to_port = 443
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.eks-controlplane.id
}

## Bastion SG
resource "aws_security_group" "bastion" {
  name = "bastion"
  vpc_id = var.aws_vpc_id

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-bastion"
  }))
}

resource "aws_security_group_rule" "bastion-egress" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 65535
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.bastion.id 
}

resource "aws_security_group_rule" "bastion-ingress" {
  type = "ingress"
  cidr_blocks = [var.workstation-external-cidr]
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.bastion.id
}

# VPC endpoint
resource "aws_security_group" "vpc-endpoint-ecr" {
  name = "vpc-endpoint-ecr"
  vpc_id = var.aws_vpc_id

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-vpc-endpoint-ecr"
  }))
}

resource "aws_security_group_rule" "vpc-endpoint-ecr-egress" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 65535
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.vpc-endpoint-ecr.id 
}

resource "aws_security_group_rule" "vpc-endpoint-ecr-ingress" {
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.vpc-endpoint-ecr.id
}