# EC2 image
data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220207.1-x86_64-gp2"]
  }

   owners =["137112412989"]
}

data aws_availability_zones available {}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_vpc_endpoint_service" "ecr_dkr" {
  service_type = "Interface"
  filter {
    name   = "service-name"
    values = ["*ecr.dkr*"]
  }
}