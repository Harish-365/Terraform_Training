##AWS ELB configuration:

resource "aws_elb" "levelup-elb" {
    name = "levelup-elb"
    subnets = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]
    security_groups = [aws_security_group.levelup-securityelb.id]
    listener {
      instance_port = 80 ##"our ec2 instance"
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }
    health_check {
      healthy_threshold = 2  ## - The instance must pass 2 consecutive health checks to be considered healthy.
      unhealthy_threshold = 2 ## - The instance must fail 2 consecutive health checks before being marked unhealthy.
      timeout = 3 ## -  If an instance doesn’t respond within 3 seconds, it’s considered a failed check.
      target = "HTTP:80/" ## - The load balancer checks the root URL (/) on port 80 using HTTP to verify if the instance is healthy.
      interval = 30 ## - Health checks happen every 30 seconds.
    }

    cross_zone_load_balancing = true ## - I- This ensures that the load balancer distributes traffic evenly across all availability zones.
    connection_draining = true ## If an instance is marked for removal (or becomes unhealthy), this setting allows active connections to finish before the instance is detached.
    connection_draining_timeout = 400 ##- Defines how long the load balancer should wait for existing connections to complete before shutting down the instance.
                                      ##- In this case, the load balancer will wait 400 seconds before terminating an instance that is draining connections. 


    tags = {
      Name = "levelup-elb"
    }

    
}

## security group for elb

resource "aws_security_group" "levelup-securityelb" { 
    vpc_id = aws_vpc.levelup_vpc.id
    name = "levelup-securityelb"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      Name = "levelup-securityelb"
    }
}

## security group for instances

resource "aws_security_group" "levelup-security-instance" { 
    vpc_id = aws_vpc.levelup_vpc.id
    name = "levelup-security-instance"
    
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

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.levelup-securityelb.id] 
        ## - Instead of allowing requests from any IP address (cidr_blocks = ["0.0.0.0/0"]), 
        ## it only allows traffic coming from the ELB security group (levelup-securityelb)
    }

    tags = {
      Name = "levelup-security-instance"
    }
}