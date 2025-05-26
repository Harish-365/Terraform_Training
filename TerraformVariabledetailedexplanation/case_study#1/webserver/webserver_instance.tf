module "levelup-vpc" {
    source = "../module/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION
  
}

module "levelup-rds" {
    source = "../module/rds"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION
  
}

##security group for webserver

resource "aws_security_group" "levelup_webservers" {
    name = "${var.ENVIRONMENT}-levelup-webservers"
    vpc_id = var.vpc_id
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.SSH_CIRD_WEB_SERVER}"]

    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
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
        Name = "${var.ENVIRONMENT}-levelup-webservers"
    }

  
}

##Resouce key pair

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.public_key_path)
  
}

## auto scaling launch template for the instance

resource "aws_launch_template" "levelup-launch-webserver" {
  name_prefix   = "levelup-launch-webserver"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE
  key_name      = aws_key_pair.levelup_key.key_name
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.levelup_webservers.id]
  }
  user_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get -y install net-tools nginx
MYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`
echo 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html
EOF
)

  lifecycle {
    create_before_destroy = true

  }
}

##create auto scaling group

resource "aws_autoscaling_group" "levelup_webautoscale" {
    name = "levelup_webautoscale"
    max_size = 2
    min_size = 1
    health_check_grace_period = 30
    health_check_type = "EC2"
    desired_capacity = 1
    force_delete = true
    launch_template {
        id = aws_launch_template.levelup-launch-webserver.id
        version = "$Latest"
    }
    vpc_zone_identifier = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]
    target_group_arns = [aws_lb_target_group.load-balancer-target-group.arn]

}

## Application load balancer for webservers

resource "aws_lb" "levelup-load-balancer" {
    name = "${var.ENVIRONMENT}-levelup-elb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.levelup_webservers_alb.id]
    subnets = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]
    }
  
##adding target group

resource "aws_lb_target_group" "load-balancer-target-group" {
    name = "load-balancer-target-group"
    port = 80   
    protocol = "HTTP"
    vpc_id = var.vpc_id
}

## adding http listener

resource "aws_lb_listener" "webserver_listener" {
    load_balancer_arn = aws_lb.levelup-load-balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
      type = "forward"
    }

  
}

output "load_balancer_output" {
    value = aws_lb.levelup-load-balancer.dns_name
  
}