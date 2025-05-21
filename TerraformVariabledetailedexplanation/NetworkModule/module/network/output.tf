output "vpc_id" {
    value = aws_vpc.levelup-vpc.id
  
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "sg_22_id" {
  value = aws_security_group.sg_22.id
}