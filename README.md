# AWS_Terraform_module
A Terraform module for creating an AWS web application server with a launch configuration and a launch configuration for it, with a Elastic Load Balancer in a VPC.
  * To launch a VPC with a configuration to scale the subnets for future growth.
  * Configuration includes a public and a private subnets, where private is associated with backend instances and end users contact the public facing load balancer.
  * Security group designed for all teh insatnces in the ASG ehich allows minimal ports for communication and backend management.
  * The AWS generated load balancer DNS name will be used for accessing the public facing web application.
  * The ASG utilizes the lastest AMI and contains a root and two EBS volumes for apps and logs mounted , the data is encrypted at rest.
  * The ASG automatically scales and removes nodes based on the alarm mechanism from cloudwatch for CPU utilization.

# Inputs

aws_access_key - Access_key need to be provided for the launch configuration.
aws_secret_key - AWS secret key need to be provided for the launc configuration.
instance_type - Instance type is appropriate mix of resources for your applications and computing needs
security_group - The Security Group ID that instances in the ASG
user_data - The path to the user_data file for the Launch Configuration.Terraform will include the contents of this file in the Launch Configuration.
asg_name - The Auto-Scaling group name.
health_check_grace_period - Number of seconds for the health check time out. Defaults to 300.
health_check_type - The health check type. Options are ELB and EC2. It defaults to ELB in this module.
availability_zones - CSV of availability zones (AZs) for the ASG. ex. "us-east-1a,us-east-1b".
vpc_zone_subnets - CSV of VPC subnets to associate with ASG.
ami_id - Utilizes the latest AMI.
vpc_cidr - The VPC IPv4 CIDR Block.
public_subnets_cidr - List of Public subnet IPS . Can be scalable for future growth.
private_subnets_cidr - List of Public subnet IPS . Can be scalable for future growth.
aws_region - AWS region where teh module needs to be launched.

# Output

elb-dns-name - Load Balancer DNS name. To be used for accessing the public facing web application.


