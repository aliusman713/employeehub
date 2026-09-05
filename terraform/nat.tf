resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "employeehub-${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "employeehub" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.employeehub
  ]

  tags = {
    Name = "employeehub-${var.environment}-nat"
  }
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.employeehub.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.employeehub.id
  }

  tags = {
    Name = "employeehub-${var.environment}-private-app-rt"
  }
}

resource "aws_route_table_association" "private_app" {
  count = 2

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app.id
}
