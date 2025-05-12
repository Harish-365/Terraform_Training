##Define External IP (ELastic IP)
resource "aws_eip" "levelup-nat" {
}

resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id

  tags = {
    Name = "levelup-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gw]
}

resource "aws_route_table" "levelup-private" {
  vpc_id = aws_vpc.levelup_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id
  }

  tags = {
    Name = "levelup-private"
  }
}

##Routing association: Assigns a subnet to a specific route table.
resource "aws_route_table_association" "levelup-private-1a" {
  subnet_id      = aws_subnet.levelupvpc-private-1.id
  route_table_id = aws_route_table.levelup-private.id
}
