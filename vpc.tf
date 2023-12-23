resource "aws_vpc" "terraform_vpc" {
  tags = {
    Name = "Terraform VPC"
  }
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnets" {
  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
}

resource "aws_internet_gateway" "vpc_igw" {
  tags = {
    Name : "Terraform VPC IGW"
  }
  vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_route_table" "terraform_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "Terraform Custom Route Table"
  }
}

resource "aws_route_table_association" "arta" {
  count          = 2
  route_table_id = aws_route_table.terraform_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}