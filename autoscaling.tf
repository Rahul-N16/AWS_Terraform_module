#Autoscale the instances with Autoscaling policies

locals  {
  terraform_subnet_ids  = aws_subnet.private.*.id
}

locals {
 asg_name = flatten(aws_autoscaling_group.webserver_ASG.*.name)[0]
}

resource "aws_autoscaling_group" "webserver_ASG" {
  count = "1" 
  launch_configuration = aws_launch_configuration.webserver.id
  vpc_zone_identifier = local.terraform_subnet_ids
  min_size = 2
  max_size = 10
  desired_capacity = 2
  load_balancers = [aws_elb.terra-elb.name]
  health_check_type = "ELB"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  tag {
    key = "Name"
    value = "Web-Servers"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = local.asg_name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = local.asg_name
  }
}  
resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = local.asg_name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = local.asg_name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_down.arn ]
}
