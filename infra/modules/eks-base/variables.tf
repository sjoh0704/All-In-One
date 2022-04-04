variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key"
}

variable "AWS_SSH_KEY_NAME" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS Region"
}

//General Cluster Settings

variable "aws_cluster_name" {
  description = "Name of AWS Cluster"
}

//AWS VPC Variables

variable "aws_vpc_cidr_block" {
  description = "CIDR Block for VPC"
}

variable "aws_cidr_subnets_public" {
  description = "CIDR Blocks for public subnets in Availability Zones"
  type        = list(string)
}

variable "aws_cidr_subnets_private" {
  description = "CIDR Blocks for private subnets in Availability Zones"
  type        = list(string)
}



/*
* EC2 Source/Dest Check
*
*/
variable "aws_src_dest_check" {
  description = "Instance source/destination check of Kubernetes Cluster"
  type = bool
  default	= true
}

variable "default_tags" {
  description = "Default tags for all resources"
  type = map(string)
}

variable "spot_instance" {
  type = bool
  default = false
}

variable "aws_instance_type" {
  type  = list(string)
  default = ["t3.medium"]
}

variable "aws_eks_instance_size" {
  type = map(string)
  default = {
    "desired" = 1
    "min" = 1
    "max" = 3 
  }
}

variable "aws_instance_disk_size" {
  type = number
  default = 40
}

variable "aws_bastion_size" {
  type = string
  default = "t3.micro"
}

variable "aws_bastion_num" {
  type = number
  default = 1
}

variable "cluster_log_types" {
  type = list
  default = ["api", "audit"]
}

variable "cluster_version" {
  type = string
  default = "1.21"
}