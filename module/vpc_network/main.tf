resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = "true"
  tags = {
    Name = "kubernetes-aws-vpc-${terraform.workspace}"
  }
}

#VPC Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main_vpc.id
}
#VPC NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sub1.id

  tags = {
    Name = "kubernetes-aws-vpc-${terraform.workspace}"
  }
}
resource "aws_eip" "nat_eip" {
  vpc   = true
}

# VPC Subnets
#Privatet Subnets
resource "aws_subnet" "private_sub1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.sub_private_cidr_1
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "kubernetes-aws-subnet-private-${terraform.workspace}-1"
     "kubernetes.io/cluster/kubernetes-aws-${terraform.workspace}" = "shared"
     "kubernetes.io/role/internal-elb"             = "1"

  }
}
resource "aws_subnet" "private_sub2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.sub_private_cidr_2
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "kubernetes-aws-subnet-private-${terraform.workspace}-2"
     "kubernetes.io/cluster/kubernetes-aws-${terraform.workspace}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"

  }
}
#Public Subnets
resource "aws_subnet" "public_sub1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.sub_public_cidr_1
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "kubernetes-aws-subnet-public-${terraform.workspace}-2"
    "kubernetes.io/cluster/kubernetes-aws-${terraform.workspace}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_subnet" "public_sub2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.sub_public_cidr_2
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "kubernetes-aws-subnet-public-${terraform.workspace}-1"
    "kubernetes.io/cluster/kubernetes-aws-${terraform.workspace}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    
  }
}



#VPC Route Tables
#Public Route Table and Association 
resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
  tags = {
    Name = "public-route-${terraform.workspace}"
  }
}


#Private Route Table and Association 
resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private-route-${terraform.workspace}"
  }
}
resource "aws_route_table_association" "route_private_sub1_association" {
  subnet_id      = aws_subnet.private_sub1.id
  route_table_id = aws_route_table.route_private.id
}
resource "aws_route_table_association" "route_private_sub2_association" {
  subnet_id      = aws_subnet.private_sub2.id
  route_table_id = aws_route_table.route_private.id
}
resource "aws_route_table_association" "route_public_sub1_association" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.route_public.id
}
resource "aws_route_table_association" "route_public_sub2_association" {
  subnet_id      = aws_subnet.public_sub2.id
  route_table_id = aws_route_table.route_public.id
}
