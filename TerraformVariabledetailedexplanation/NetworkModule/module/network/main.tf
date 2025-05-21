## AWS resource for VPC

resource "aws_vpc" "levelup-vpc" {
    cidr_block = var.cidr_vpc
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "levelup-vpc"
      Environment = var.environment_tag
    }
  
}

## resource for subnet

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.levelup-vpc.id
    cidr_block = var.cidr_subnet
    map_public_ip_on_launch = "true"
    availability_zone = var.availability_zone

    tags = {
      Environment = var.environment_tag
    }
  
}

## internet gateway for public subnet

resource "aws_internet_gateway" "levelup-igw" {
    vpc_id = aws_vpc.levelup-vpc.id

    tags = {
      Environment = var.environment_tag
    }
  
}

## route table for VPC

resource "aws_route_table" "levelup-rtb-public" {
    vpc_id = aws_vpc.levelup-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.levelup-igw.id

    }
    tags = {
      Environment = var.environment_tag
    }
} 

## route table association

resource "aws_route_table_association" "levelup-rta-subnet-public" {
    route_table_id = aws_route_table.levelup-rtb-public.id
    subnet_id = aws_subnet.public-subnet.id
  
}

## AWS security group

resource "aws_security_group" "levelup-security" {
    name = "levelup-security"
    vpc_id = aws_vpc.levelup-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = var.environment_tag

    }
}   