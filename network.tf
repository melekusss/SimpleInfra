#VPC for our infrastructure
resource "aws_vpc" "main-vpc" {
  cidr_block = var.cidr-block

  tags = {
    Name    = "VPC-simpleinfra"
    Project = "simpleinfra"
  }
}

#Creation of VPC public subnets
resource "aws_subnet" "public-subnets" {
  count             = length(var.public-subnet-cidrs)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = element(var.public-subnet-cidrs, count.index)
  availability_zone = element(var.azs-eu-central-1, count.index)

  tags = {
    Name    = "Public Subnet no. ${count.index + 1}"
    Project = "simpleinfra"
  }
}

#Creation of VPC private subnets
resource "aws_subnet" "private-subnets" {
  count             = length(var.private-subnet-cidrs)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = element(var.private-subnet-cidrs, count.index)
  availability_zone = element(var.azs-eu-central-1, count.index)

  tags = {
    Name    = "Private Subnet no. ${count.index + 1}"
    Project = "simpleinfra"
  }
}

#Creation of internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name    = "VPC-IGW-simpleinfra"
    Project = "simpleinfra"
  }
}

#Creation of route table for public subnets
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "Public route table"
    Project = "simpleinfra"
  }
}

#Associate Public route table with public subnets
resource "aws_route_table_association" "public-subnets-association" {
  count          = length(var.public-subnet-cidrs)
  subnet_id      = element(aws_subnet.public-subnets[*].id, count.index)
  route_table_id = aws_route_table.rt-public.id
}
