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
}

## Auto scaling group:

resource "aws_autoscaling_group" "levelup-autoscaling" {
    name = "levelup-autoscaling"
    vpc_zone_identifier = ["subnet-05c89a7f34226dece"]
launch_template {
    id      = aws_launch_template.levelup-launch-template.id
    version = "$Latest"
  }

    min_size = 1 ##minimum instance should be there
    max_size = 2
    health_check_grace_period = 200 ## after 200s of the continous instance failure then it will create a new instance
    health_check_type = "EC2"
    force_delete = true  ## in Auto Scaling to ensure resources are deleted, even if they are still running.

    tag {
        key = "Name"
        value = "Levelup Custom Ec2 instance"
        propagate_at_launch = true ## ensures that tags applied to the Auto Scaling Group (ASG) are automatically assigned to newly launched instances.

    }
}

## Auto scaling policy for increasing
resource "aws_autoscaling_policy" "levelup-cpu-policy" {
    name = "levelup-cpu-policy"
    autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
    adjustment_type = "ChangeInCapacity" ##determines how scaling adjustments are made when scaling policies trigger changes.
    scaling_adjustment = 1 ## scaling will be done one machine at a time
    cooldown = "200"  ## - After an instance is added or removed, Auto Scaling waits 200 seconds before making another scaling decision.
    policy_type = "SimpleScaling" ## - Uses basic threshold-based scaling rules
  
}

## Autoscaling cloud watch monitoring and if we don't monitor the EC2 instances then how the autoscalling will be triggered.

resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm" {
    alarm_name = "levelup-cpu-alarm"
    alarm_description = "Allow once CPU usage Increase"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2" ## The scaling policy will check the metric over two consecutive periods before taking action.
    metric_name = "CPUUtilization" ## The Auto Scaling Group monitors CPU usage of EC2 instances.
    namespace = "AWS/EC2" ## ensures Auto Scaling retrieves the correct metric data from EC2 instances.
    period = 120 ## The alarm evaluates the metric every 120 seconds
    statistic = "Average"  ## Uses the average value of the metric over the period to make scaling decisions.
    threshold = 30 ## The alarm triggers when the metric crosses 30, signaling Auto Scaling to take action.
    ## - If average CPU utilization exceeds 30% for two consecutive evaluation periods (each 120 seconds), the alarm is triggered.

    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name ## - Specifies that this alarm is monitoring the "levelup-autoscaling" Auto Scaling Group.
    ## This dimensions setting is important because it ensures that your CloudWatch alarm only monitors metrics for the specific Auto Scaling Group (levelup-autoscaling)
    ## rather than all EC2 instances or other groups.


    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.levelup-cpu-policy.arn]
}

## define the policy for auto descaling as well.. this will maintain the cost, whenever the traffic is reduced and if the CPU is below the threshold then it 
## try to delete the instance. 

resource "aws_autoscaling_policy" "levelup-cpu-policy-scaledown" {
    name = "levelup-cpu-policy-scaledown"
    autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
    adjustment_type = "ChangeInCapacity" ##determines how scaling adjustments are made when scaling policies trigger changes.
    scaling_adjustment = "-1"  ## scaling will be done one machine at a time
    cooldown = "200"  ## - After an instance is added or removed, Auto Scaling waits 200 seconds before making another scaling decision.
    policy_type = "SimpleScaling" ## - Uses basic threshold-based scaling rules
  
}

## clould watch alarm for descaling

resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm-scaledown" {
    alarm_name = "levelup-cpu-alarm-scaledown"
    alarm_description = "Allow once CPU usage decreases"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2" ## The scaling policy will check the metric over two consecutive periods before taking action.
    metric_name = "CPUUtilization" ## The Auto Scaling Group monitors CPU usage of EC2 instances.
    namespace = "AWS/EC2" ## ensures Auto Scaling retrieves the correct metric data from EC2 instances.
    period = 120 ## The alarm evaluates the metric every 120 seconds
    statistic = "Average"  ## Uses the average value of the metric over the period to make scaling decisions.
    threshold = 10 ## The alarm triggers when the metric crosses 30, signaling Auto Scaling to take action.
    ## - If average CPU utilization exceeds 30% for two consecutive evaluation periods (each 120 seconds), the alarm is triggered.

    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name ## - Specifies that this alarm is monitoring the "levelup-autoscaling" Auto Scaling Group.
    ## This dimensions setting is important because it ensures that your CloudWatch alarm only monitors metrics for the specific Auto Scaling Group (levelup-autoscaling)
    ## rather than all EC2 instances or other groups.


    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.levelup-cpu-policy-scaledown.arn]
}
