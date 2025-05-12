resource "aws_security_group" "levelup-security" {
    name = "levelup-security"
    vpc_id = aws_vpc.levelup_vpc.id
    ingress { ## Inbound traffic
        from_port = "22" ##allowing ssh port so that we can connect using ssh to the remote VM
        to_port = "22" ##  This allows SSH (port 22) from anywhere (0.0.0.0/0). Since both ports are the same, it allows only port 22.
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] ## here the cidr block is mentioned with in the [] which means it is a list and it allows any kind of ip.
    }

    egress { ## outbound traffic
        from_port = "0"
        to_port = "0"
        protocol = "-1" ## here -1 is a special character in terraform which means it will all kind of protocal
        cidr_blocks = ["0.0.0.0/0"] 
    }

tags = {
    Name = "levelup-security"
}
  
}