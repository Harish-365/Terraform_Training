##Define External IP (ELastic IP)
resource "aws_eip" "levelup-nat" {
}

resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id  ## - A private subnet does not have direct internet access—it relies on the NAT Gateway in the public subnet to send outbound traffic.
# Why is the NAT Gateway in a Public Subnet?
# ✔ NAT Gateways require an Elastic IP (EIP), which means they need to be in a subnet that can connect to the Internet Gateway (IGW).
# ✔ A private subnet cannot directly communicate with the internet, so it routes requests through the NAT Gateway in the public subnet.
# ✔ Private subnet instances use routing tables to send outbound requests to the NAT Gateway.
# Recap:
# ✅ VPC is private by design, but it contains both public and private subnets.
# ✅ The NAT Gateway sits in a public subnet because it needs an EIP to reach the internet.
# ✅ Instances in private subnets send traffic to the NAT Gateway to access the internet, while remaining inaccessible from external inbound traffic.
# Want help with VPC routing tables or setting up secure networking best practices? 🚀

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
