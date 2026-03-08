
#------- Creating a VPC -------#

resource "aws_vpc" "shakirs_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Shakir's Production VPC"
  }
}

#
#
#

#------- Creating Internet Gateway -------#

resource "aws_internet_gateway" "shakirs_igw" {
  vpc_id = aws_vpc.shakirs_vpc.id

  tags = {
    Name = "Prod Igw"
  }
}

#
#
#

#------- Creating Public Subnets  -------#

resource "aws_subnet" "shakirs_pub_sn_1a" {
  vpc_id            = aws_vpc.shakirs_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Public Subnet 1a"
  }
}

resource "aws_subnet" "shakirs_pub_sn_1b" {
  vpc_id            = aws_vpc.shakirs_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Public Subnet 1b"
  }
}

#
#
#

#------- Creating Route Table For Public Subnets & Attaching Igw -------#

resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.shakirs_vpc.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.shakirs_igw.id
  }

  tags = {
    Name = "Route Table With Internet"
  }
}

#
#
#

#------- Attaching  Route Tables With Public Subnets  -------#

#### We will attach one route table to both subnets to make them Public ###

resource "aws_route_table_association" "pub_rt_associate_1a" {
  subnet_id      = aws_subnet.shakirs_pub_sn_1a.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "pub_rt_associate_1b" {
  subnet_id      = aws_subnet.shakirs_pub_sn_1b.id
  route_table_id = aws_route_table.pub_route_table.id
}

#
#
#

#------- Creating Private Subnets  -------#

resource "aws_subnet" "shakirs_pvt_sn_1a" {
  vpc_id            = aws_vpc.shakirs_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private Subnet 1a"
  }
}

resource "aws_subnet" "shakirs_pvt_sn_1b" {
  vpc_id            = aws_vpc.shakirs_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private Subnet 1b"
  }
}

#
#
#

#------- Creating Elastic IP's For NAT Gateway -------#

resource "aws_eip" "shakirs_elastic_ip_1" {
  domain = "vpc"
}

resource "aws_eip" "shakirs_elastic_ip_2" {
  domain = "vpc"
}

#
#
#

#------- Creating NAT Gateways -------#

resource "aws_nat_gateway" "shakirs_nat_1a" {
  allocation_id = aws_eip.shakirs_elastic_ip_1.id
  subnet_id     = aws_subnet.shakirs_pub_sn_1a.id
}

resource "aws_nat_gateway" "shakirs_nat_1b" {
  allocation_id = aws_eip.shakirs_elastic_ip_2.id
  subnet_id     = aws_subnet.shakirs_pub_sn_1b.id
}

#
#
#

#------- Creating Route Tables For Private Subnets -------#

resource "aws_route_table" "pvt_route_table_1a" {
  vpc_id = aws_vpc.shakirs_vpc.id

  route {
    cidr_block     = var.internet_cidr
    nat_gateway_id = aws_nat_gateway.shakirs_nat_1a.id
  }

  tags = {
    Name = "Route Table With NAT In 1a"
  }
}

resource "aws_route_table" "pvt_route_table_1b" {
  vpc_id = aws_vpc.shakirs_vpc.id

  route {
    cidr_block     = var.internet_cidr
    nat_gateway_id = aws_nat_gateway.shakirs_nat_1b.id
  }

  tags = {
    Name = "Route Table With NAT In 1b"
  }
}

#
#
#

#------- Attaching Route Tables To Private Subnets -------#

resource "aws_route_table_association" "pvt_rt_associate_1a" {
  subnet_id      = aws_subnet.shakirs_pvt_sn_1a.id
  route_table_id = aws_route_table.pvt_route_table_1a.id
}

resource "aws_route_table_association" "pvt_rt_associate_1b" {
  subnet_id      = aws_subnet.shakirs_pvt_sn_1b.id
  route_table_id = aws_route_table.pvt_route_table_1b.id
}

