
# security group
resource "aws_security_group" "eks-cluster" {
  name        = "eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, tomap({
    Name = "eks-cluster"
  }))
}


# ingress rule
resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
    ## TO DO: 나만 들어갈 수 있는건지 체크
  cidr_blocks       = [var.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
  to_port           = 443
  type              = "ingress"
}