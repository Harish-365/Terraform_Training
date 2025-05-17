resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.AWS_PUBLICKEY) ## create key uisng ssh-keygen -f levelup_key
}

resource "aws_instance" "Myfirstinstance" {
    ami = lookup(var.AMIS, var.AWS_REGION)
    vpc_security_group_ids = [aws_security_group.levelup-security.id]
    instance_type = "t2.micro"
    availability_zone = "us-east-1f"
    key_name      = aws_key_pair.levelup_key.key_name 
    subnet_id = aws_subnet.levelup-public.id

    tags = {
        Name = "Myfirstinstance"
    }
}

output "public_ip" {
    value = aws_instance.Myfirstinstance.public_ip
  
}