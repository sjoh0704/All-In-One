#Global Vars
aws_cluster_name = "my-eks-test"

#VPC Vars
aws_vpc_cidr_block = "10.0.0.0/16"
aws_cidr_subnets_public = ["10.0.1.0/24", "10.0.2.0/24"]
aws_cidr_subnets_private = ["10.0.3.0/24", "10.0.4.0/24"]


#EC2 Source/Dest Check
aws_src_dest_check = false

default_tags = {}

# #The number of EC2 and EC2 size

spot_instance = true

aws_instance_type = ["m5.large"]

aws_eks_instance_size = {
    desired = 1
    min = 1
    max = 3 
}

# # The number of bastion and bastion size
aws_bastion_size = "t3.micro"
aws_bastion_num = 1

