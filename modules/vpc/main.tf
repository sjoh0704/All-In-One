resource "aws_vpc" "vpc" {
  cidr_block = var.aws_vpc_cidr_block

  #DNS Related Entries
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-vpc"
    "kubernetes.io/cluster/${var.aws_cluster_name}" = "shared"
  }))
}

resource "aws_eip" "nat-eip" {
  count = length(var.aws_cidr_subnets_private) == 0 ? 0: length(var.aws_cidr_subnets_public) 
  vpc   = true
}

resource "aws_internet_gateway" "vpc-internetgw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-igw"
  }))
}

resource "aws_subnet" "subnet-public" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.aws_cidr_subnets_public)
  availability_zone = element(var.aws_avail_zones, count.index % length(var.aws_avail_zones))
  cidr_block        = element(var.aws_cidr_subnets_public, count.index)

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-public"
    "kubernetes.io/cluster/${var.aws_cluster_name}" = "shared"
  }))
}

resource "aws_nat_gateway" "nat-gateway" {
  count         = length(var.aws_cidr_subnets_private) == 0 ? 0: length(var.aws_cidr_subnets_public)
  allocation_id = element(aws_eip.nat-eip.*.id, count.index)
  subnet_id     = element(aws_subnet.subnet-public.*.id, count.index)
}

resource "aws_subnet" "subnet-private" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.aws_cidr_subnets_private)
  availability_zone = element(var.aws_avail_zones, count.index % length(var.aws_avail_zones))
  cidr_block        = element(var.aws_cidr_subnets_private, count.index)

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-private"
    "kubernetes.io/cluster/${var.aws_cluster_name}" = "shared"
  }))
}


resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-internetgw.id
  }

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-route-table-public"
  }))
}

resource "aws_route_table" "private-route-table" {
  count  = length(var.aws_cidr_subnets_private)
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.default_tags, tomap({
    Name = "${var.aws_cluster_name}-routetable-private-${count.index}"
  }))
}

resource "aws_route" "route_with_nat_gatway" {
  count  = length(var.aws_cidr_subnets_private) == 0 ? 0: length(var.aws_cidr_subnets_public) 
  route_table_id =  element(aws_route_table.private-route-table.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.nat-gateway.*.id, count.index) 
}


resource "aws_route_table_association" "public-rt-association" {
  count          = length(var.aws_cidr_subnets_public)
  subnet_id      = element(aws_subnet.subnet-public.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-rt-association" {
  count          = length(var.aws_cidr_subnets_private)
  subnet_id      = element(aws_subnet.subnet-private.*.id, count.index)
  route_table_id = element(aws_route_table.private-route-table.*.id, count.index)
}
