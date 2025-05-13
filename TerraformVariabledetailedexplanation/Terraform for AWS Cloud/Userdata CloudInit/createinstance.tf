resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.AWS_PUBLICKEY) ## create key uisng ssh-keygen -f levelup_key
}

resource "aws_instance" "Myfirstinstance" {
    ami = lookup(var.AMIS, var.AWS_REGION)
    instance_type = "t2.micro"
    key_name      = aws_key_pair.levelup_key.key_name 
    user_data = data.template_cloudinit_config.install-apache-config.rendered

    tags = {
        Name = "Myfirstinstance"
    }
}

output "public_ip" {
    value = aws_instance.Myfirstinstance.public_ip
}

