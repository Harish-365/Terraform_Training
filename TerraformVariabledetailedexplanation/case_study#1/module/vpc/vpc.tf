provider "aws" {
    region = var.AWS_REGION
  
}

data "aws_availability_zones" "available" {
    state = "available"
}

##Main VPC

resource "aws_vpc" "levelup_vpc" {

    cidr_block = var.LEVEL_VPC_CIDR_BLOCK
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.ENVIRONMENT}-vpc"
    }

  
}

##private subnet1

resource "aws_subnet" "levelup_vpc_private_subnet_1" {
    vpc_id = aws_vpc.levelup_vpc.id
    cidr_block = var.LEVEL_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-1"
    }
      
}

##private subnet2

resource "aws_subnet" "levelup_vpc_private_subnet_2" {
    vpc_id = aws_vpc.levelup_vpc.id
    cidr_block = var.LEVEL_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-2"
    }
  
}

##public subnet1

resource "aws_subnet" "levelup_vpc_public_subnet_1" {
    vpc_id = aws_vpc.levelup_vpc.id
    cidr_block = var.LEVEL_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-1"
    }
  
}

##public subnet2

resource "aws_subnet" "levelup_vpc_public_subnet_2" {
    vpc_id = aws_vpc.levelup_vpc.id
    cidr_block = var.LEVEL_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-2"
    }
  
}

#internet_gateway

resource "aws_internet_gateway" "levelup_igw" {
    vpc_id = aws_vpc.levelup_vpc.id

    tags = {
      Name = "${var.ENVIRONMENT}-levelup-vpc-internet-gateway"
    }
  
}

##elastic IP for NAT Gateway >> assigns the public ip to the nat gateway for accessing the internet

resource "aws_eip" "levelup_nat_eip" {
    depends_on = [aws_internet_gateway.levelup_igw]
  
}

## NAT gateway for private ip_address

resource "aws_nat_gateway" "levelup_ngw" {
    allocation_id = aws_eip.levelup_nat_eip.id
    subnet_id = aws_subnet.levelup_vpc_public_subnet_1.id
    depends_on = [aws_internet_gateway.levelup_igw]

    tags = {
      Name = "${var.ENVIRONMENT}-levelup-vpc-nat-gateway"
    }
  
}

##Route table for Public subents

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.levelup_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.levelup_igw.id

    }

    tags = {
        Name = "${var.ENVIRONMENT}-levelup-public-route-table"
    }
  
}

##Route table for Private subents

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.levelup_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.levelup_ngw.id

    }

    tags = {
        Name = "${var.ENVIRONMENT}-levelup-private-route-table"
    }
  
}

##route table assocation for private network

resource "aws_route_table_association" "to_private_subnet1" {
    subnet_id = aws_subnet.levelup_vpc_private_subnet_1.id
    route_table_id = aws_route_table.private.id
  
}

resource "aws_route_table_association" "to_private_subnet2" {
    subnet_id = aws_subnet.levelup_vpc_private_subnet_2.id
    route_table_id = aws_route_table.private.id
  
}

##route table assocation for public network

resource "aws_route_table_association" "to_public_subnet1" {
    subnet_id = aws_subnet.levelup_vpc_public_subnet_1.id
    route_table_id = aws_route_table.public.id
  
}

resource "aws_route_table_association" "to_public_subnet2" {
    subnet_id = aws_subnet.levelup_vpc_public_subnet_2.id
    route_table_id = aws_route_table.public.id
  
}

output "my_vpc_id" {
    value = aws_vpc.levelup_vpc.id
  
}

output "private_subnet1_id" {
    value = aws_subnet.levelup_vpc_private_subnet_1.id
  
}

output "private_subnet2_id" {
    value = aws_subnet.levelup_vpc_private_subnet_2.id
  
}

output "public_subnet1_id" {
    value = aws_subnet.levelup_vpc_public_subnet_1.id
  
}

output "public_subnet2_id" {
    value = aws_subnet.levelup_vpc_public_subnet_2.id
  
}