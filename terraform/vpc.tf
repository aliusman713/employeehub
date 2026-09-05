resource "aws_vpc" "employeehub" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "employeehub-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "employeehub" {
  vpc_id = aws_vpc.employeehub.id

  tags = {
    Name = "employeehub-${var.environment}-igw"
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.employeehub.id
  cidr_block              = cidrsubnet(aws_vpc.employeehub.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "employeehub-${var.environment}-public-${count.index + 1}"
    Tier = "public"
  }
}

resource "aws_subnet" "private_app" {
  count = 2

  vpc_id            = aws_vpc.employeehub.id
  cidr_block        = cidrsubnet(aws_vpc.employeehub.cidr_block, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "employeehub-${var.environment}-private-app-${count.index + 1}"
    Tier = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.employeehub.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.employeehub.id
  }

  tags = {
    Name = "employeehub-${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_db" {
  count = 2

  vpc_id            = aws_vpc.employeehub.id
  cidr_block        = cidrsubnet(aws_vpc.employeehub.cidr_block, 8, count.index + 20)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "employeehub-${var.environment}-private-db-${count.index + 1}"
    Tier = "database"
  }
}
