##public key

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.AWS_PUBLICKEY)
  
}

# the name_prefix argument in Terraform is used to set a prefix for resource names, and AWS automatically appends a random suffix to make each name unique.
# 🔹 How name_prefix Works
# - Instead of specifying an exact name (name), Terraform allows AWS to generate unique names by appending random characters.
# - Useful when you don’t need an exact name but require distinct resource identifiers. 
# - Terraform might create my-launch-config-abc123 or my-launch-config-xyz789, ensuring uniqueness.
# 🔹 Why Use name_prefix?
# ✅ Prevents name conflicts.
# ✅ Ideal for auto-generated names in Auto Scaling Groups, S3 buckets, and EC2 instances.
# ✅ Helps when scaling multiple resources dynamically.

##Launch configuration:
resource "aws_launch_template" "levelup-launch-template" {
  name_prefix   = "levelup-launch-template"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
  vpc_security_group_ids = [aws_security_group.levelup-security-instance.id]
  user_data = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"

  lifecycle {
    create_before_destroy = true

  }
}

## Auto scaling group:

resource "aws_autoscaling_group" "levelup-autoscaling" {
    name = "levelup-autoscaling"
    vpc_zone_identifier = [aws_subnet.levelupvpc-public-1, aws_subnet.levelupvpc-public-2]
launch_template {
    id      = aws_launch_template.levelup-launch-template.id
    version = "$Latest"
  }

    min_size = 2 ##minimum instance should be there
    max_size = 2
    health_check_grace_period = 200 ## after 200s of the continous instance failure then it will create a new instance
    health_check_type = "ELB"
    load_balancers = [aws_elb.levelup-elb.name]
    force_delete = true  ## in Auto Scaling to ensure resources are deleted, even if they are still running.

    tag {
        key = "Name"
        value = "Levelup Custom Ec2 instance for ELB"
        propagate_at_launch = true ## ensures that tags applied to the Auto Scaling Group (ASG) are automatically assigned to newly launched instances.

    }
}

output "ELB" {
  value = aws_elb.levelup-elb.dns_name
  
}