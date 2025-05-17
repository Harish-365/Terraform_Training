resource "aws_security_group" "levelup-security" {
    name = "levelup-security"
    vpc_id = aws_vpc.levelup_vpc
    
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
      Name = "levelup-security"
    }
}

## security group for MariaDB
resource "aws_security_group" "security-mariadb" {
    name = "security-mariadb"
    vpc_id = aws_vpc.levelup_vpc
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.levelup-security.id]
    }
    tags = {
      Name = "security-mariadb"
    }
}
