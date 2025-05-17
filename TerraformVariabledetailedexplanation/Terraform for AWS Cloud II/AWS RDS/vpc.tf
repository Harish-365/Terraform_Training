resource "aws_vpc" "levelup_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  instance_tenancy = "default"

  tags = {
    Name = "levelup_vpc"
  }
}

resource "aws_subnet" "levelup-public" {
  vpc_id = aws_vpc.levelup_vpc.id
  availability_zone = "us-east-1f"
  map_public_ip_on_launch = "true"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "levelup-public"
  }
}

resource "aws_subnet" "levelup-private-1" {
  vpc_id = aws_vpc.levelup_vpc.id
  availability_zone = "us-east-1f"
  map_public_ip_on_launch = "true"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "levelup-private-1"
  }
}

resource "aws_subnet" "levelup-private-2" {
  vpc_id = aws_vpc.levelup_vpc.id
  availability_zone = "us-east-1f"
  map_public_ip_on_launch = "true"
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "levelup-private-2"
  }
}

resource "aws_internet_gateway" "Internet-gw" {
  vpc_id = aws_vpc.levelup_vpc.id
  
  tags = {
    Name = "Internet-gw"
    }
}

resource "aws_route_table" "levelup-public" {
  vpc_id = aws_vpc.levelup_vpc.id
  
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet-gw.id    
  }
  tags = {
    Name =levelup-public
  }
}

resource "aws_route_table_association" "level-public-1a" {
    subnet_id = aws_subnet.levelup-public.id
    route_table_id = aws_route_table.levelup-public.id
 
}
  
