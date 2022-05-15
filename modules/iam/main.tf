# EKS control plane IAM ROLE
resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster.name
}


# EKS node IAM ROLE 
resource "aws_iam_role" "eks-node" {
  name = "eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}

# oidc - vpc cni role
resource "aws_iam_role" "vpc-cni" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name = "vpc-cni-role"
}

resource "aws_iam_role_policy_attachment" "vpc-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc-cni.name
}

# oidc - aws-load-balancer-controller role
resource "aws_iam_role" "aws-load-balancer-controller" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name = "aws-load-balancer-controller-role"
}





resource "aws_iam_role_policy_attachment" "aws-load-balancer-controller-policy" {
  policy_arn = aws_iam_policy.aws-load-balancer-controller.arn
  role = aws_iam_role.aws-load-balancer-controller.name
}


resource "aws_iam_policy" "aws-load-balancer-controller" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  policy = "${file("${path.module}/policy/aws-load-balancer-controller-iam-policy.json")}"
}
