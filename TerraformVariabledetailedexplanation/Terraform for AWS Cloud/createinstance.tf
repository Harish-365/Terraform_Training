resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.AWS_PUBLICKEY) ## create key uisng ssh -keygen -f levelup_key
}

resource "aws_instance" "Myfirstinstance" {
    ami = lookup(var.AMIS.var.AWS_REGION)
    vpc_security_group_ids = aws_security_group.levelup-security
    instance_type = "t2.micro"
    key_name      = aws_key_pair.levelup_key.key_name 
    subnet_id = aws_subnet.levelupvpc-public-1.id

    tags = {
        Name = "Myfirstinstance"
    }
}