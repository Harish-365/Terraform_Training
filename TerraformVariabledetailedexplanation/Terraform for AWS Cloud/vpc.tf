##VPC
resource "aws_vpc" "levelup_vpc" {
  cidr_block = "10.0.0.0/16"  ## 10.0.255.255
  instance_tenancy = "default" ## if we don't give it to defual for this then each new instance created in this VPC will demand separate hard which will increase cost
  enable_dns_support = "true" ## this will enable the dns resolution which means converts ip in to the name
  enable_dns_hostnames = "true" ## this will make the dns_hostname like website host name 

  tags = {
    Name = "levelup_vpc"
  }
}

##Public subnet
resource "aws_subnet" "levelupvpc-public-1" {
  vpc_id     = aws_vpc.levelup_vpc.id
  cidr_block = "10.0.1.0/24" ##10.0.1.255
  map_public_ip_on_launch = "true" ## this will automatically sets the public IP
  availability_zone = "us-east-1f"

  tags = {
    Name = "levelupvpc-public-1"
  }
}

##Private subnet
resource "aws_subnet" "levelupvpc-private-1" {
  vpc_id     = aws_vpc.levelup_vpc.id
  cidr_block = "10.0.2.0/24" ##10.0.2.255
  map_public_ip_on_launch = "false" ## this will automatically sets the public IP
  availability_zone = "us-east-1f"

  tags = {
    Name = "levelupvpc-private-1"
  }
}

##Internet Gatewat
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.levelup_vpc.id
  tags = {
    Name = "internet_gw"
  }
}

##Routing table : Defines how traffic moves in/out of a subnet.
resource "aws_route_table" "levelup-Public" {
  vpc_id = aws_vpc.levelup_vpc.id

  route {
    cidr_block = "0.0.0.0/0" ## this ensure that once the instance is created it can access any website on the internet
    gateway_id = aws_internet_gateway.internet_gw.id
  }
  tags = {
    Name = "levelup-Public"
  }
}

##Routing association: Assigns a subnet to a specific route table.
resource "aws_route_table_association" "levelup-public-1a" {
  subnet_id      = aws_subnet.levelupvpc-public-1.id
  route_table_id = aws_route_table.levelup-Public.id
}
