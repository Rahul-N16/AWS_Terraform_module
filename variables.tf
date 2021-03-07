#Launch Configuration Variables

variable "aws_region" {
	description = " The region where the module is to be launched"
	default = "us-east-1"
}

variable "vpc_cidr" {
	description = " The VPC IPv4 CIDR Block " 
	default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
	description =  " Public subnets for the VPC "
	default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets_cidr" {
	description = " Private subnets for the VPC "
	default = ["10.0.16.0/20", "10.0.32.0/20"]
}

variable "azs" {
	description = " Availability zones for the subnets and instances "
	default = ["us-east-1a", "us-east-1b"]
}

variable "webservers_ami" {
  description = "The AMI to use with the launch configuration"
  default = "ami-0915bcb5fa77e4892"
}

variable "instance_type" {
  description = "Instance type is  appropriate mix of resources for your applications and computing needs"
  default = "t2.micro"
}

variable "aws_access_key" {
  description = "AWS account access key"
  }

variable "aws_secret_key" {
  description = "AWS account secret key"
  }


