resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.public_key_path)
  
}

resource "aws_security_group" "allow-ssh" {
    name = "allow-ssh-${var.ENVIRONMENT}"
    vpc_id = var.vpc_id

    egress {
        from_port = o
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      Name = "allow-ssh"
      Environment = var.ENVIRONMENT
    }
  
}

resource "aws_instance" "Myec2" {
    ami = lookup(var.AMIS, var.AWS_REGION)
    instance_type = var.INSTANCE_TYPE
    subnet_id = element(var.PUBLIC_SUBNETS)
    vpc_security_group_ids = [aws_security_group.allow-ssh.id]
    key_name = aws_key_pair.levelup_key.key_name

    tags = {
        Name = "instance-${var.ENVIRONMENT}"
        Environment = var.ENVIRONMENT
    }
  
}