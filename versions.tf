#version and provider 

terraform {
	  required_version = ">= 0.12.30"
}
provider "aws" {
	region = var.aws_region
        version = "~> 3.31"
        access_key = var.aws_access_key
	secret_key = var.aws_secret_key
}
