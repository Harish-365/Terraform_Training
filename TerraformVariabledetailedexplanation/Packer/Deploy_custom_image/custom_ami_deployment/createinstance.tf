module "MyVpc" {
    source = "../modules/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION
  
}

provider "aws" {
    region = "us-east-2"
  
}

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.public_key_path)
  
}

resource "aws_security_group" "allow-ssh" {
    name = "allow-ssh-${var.ENVIRONMENT}"
    vpc_id = module.MyVpc.my_vpc_id

    egress {
        from_port = 0
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
        Name = "allow-ssh-${var.ENVIRONMENT}"
    }
}


resource "aws_instance" "Myinstance" {
    ami = "ami-04bce0b4d85efda16"
    instance_type = var.instance_type
    subnet_id = element(module.MyVpc.public_subnets, 0)
    key_name = aws_key_pair.levelup_key.key_name
    vpc_security_group_ids = [aws_security_group.allow-ssh.id]

    tags = {
        Name = "instance-${var.ENVIRONMENT}"
        ENVIRONMENT = var.ENVIRONMENT
    }
  
}