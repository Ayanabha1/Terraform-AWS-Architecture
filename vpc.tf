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

resource "aws_internet_gateway" "terraform_vpc_igw" {
  tags = {
    Name : "Terraform VPC IGW"
  }
  vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_eip" "vpc_nat_ip" {
  domain                    = "vpc"
  associate_with_private_ip = "10.0.0.5"
  depends_on                = [aws_internet_gateway.terraform_vpc_igw]
}

resource "aws_nat_gateway" "terraform_vpc_nat" {
  allocation_id = aws_eip.vpc_nat_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = "terraform_vpc_nat"
  }
  depends_on = [aws_eip.vpc_nat_ip]
}

resource "aws_route_table" "terraform_vpc_pub_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_vpc_igw.id
  }

  tags = {
    Name = "Terraform VPC Public Route Table"
  }
}

resource "aws_route_table_association" "pub_rta" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.terraform_vpc_pub_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table" "terraform_vpc_prv_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_vpc_nat.id
  }

  tags = {
    Name = "Terraform VPC Private Route Table"
  }
}

resource "aws_route_table_association" "prv_rta" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.terraform_vpc_prv_rt.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}