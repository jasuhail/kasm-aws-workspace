# Internet VPC
resource "aws_vpc" "kasm_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Kasm Terraform"
  }
}

# Subnets
resource "aws_subnet" "kasm-public-1" {
  vpc_id                  = aws_vpc.kasm_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "Kasm Public 1"
  }
}

resource "aws_subnet" "kasm-public-2" {
  vpc_id                  = aws_vpc.kasm_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "Kasm Public 2"
  }
}

resource "aws_subnet" "kasm-public-3" {
  vpc_id                  = aws_vpc.kasm_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2c"

  tags = {
    Name = "Kasm Public 3"
  }
}

resource "aws_subnet" "main-private-1" {
  vpc_id                  = aws_vpc.kasm_vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "main-private-1"
  }
}


# Internet GW
resource "aws_internet_gateway" "kasm-gw" {
  vpc_id = aws_vpc.kasm_vpc.id

  tags = {
    Name = "Kasm IGW"
  }
}

# route tables
resource "aws_route_table" "kasm-public" {
  vpc_id = aws_vpc.kasm_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kasm-gw.id
  }

  tags = {
    Name = "Kasm Public 1"
  }
}

# route associations public
resource "aws_route_table_association" "kasm-public-1-a" {
  subnet_id      = aws_subnet.kasm-public-1.id
  route_table_id = aws_route_table.kasm-public.id
}

resource "aws_route_table_association" "kasm-public-2-a" {
  subnet_id      = aws_subnet.kasm-public-2.id
  route_table_id = aws_route_table.kasm-public.id
}

resource "aws_route_table_association" "kasm-public-3-a" {
  subnet_id      = aws_subnet.kasm-public-3.id
  route_table_id = aws_route_table.kasm-public.id
}

resource "aws_eip" "kasm_eip" {
  vpc      = true
  tags = {
    Name = "Kasm Elastic IP"
  }
}
