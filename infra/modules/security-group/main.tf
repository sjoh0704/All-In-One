
# eks cluster
## TO DO: 시큐리티 그룹 최적화
resource "aws_security_group" "eks-cluster" {
  name = "eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id = var.aws_vpc_id

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-eks-cluster"
  }))
}

resource "aws_security_group_rule" "eks-cluster-egress" {
  type = "egress" 
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 65535
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.eks-cluster.id 
}

resource "aws_security_group_rule" "eks-cluster-ingress" {
    ## TO DO: 나만 들어갈 수 있는건지 체크
  type = "ingress"
  cidr_blocks = [var.workstation-external-cidr]
  to_port = 443
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
}


# node group 
resource "aws_security_group" "eks-node" {
  name = "eks-node"
  vpc_id = var.aws_vpc_id

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-eks-node"
  }))
}

resource "aws_security_group_rule" "eks-node-egress" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 65535
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.eks-node.id 
}

resource "aws_security_group_rule" "eks-node-ingress" {
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 65535
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.eks-node.id
}





# bastion
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


