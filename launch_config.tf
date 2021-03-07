## Creating Launch Configuration
resource "aws_launch_configuration" "webserver" {
  image_id               = var.webservers_ami
  instance_type          = "t2.micro"
  security_groups        = [aws_security_group.webservers.id]
 # associate_public_ip_address = true
  user_data = file("/Terraform/Web-Application/install_httpd.sh")
  lifecycle {
    create_before_destroy = true
  }
root_block_device {
	volume_type = "gp2"
	volume_size ="10"
	encrypted = "true"
}

ebs_block_device {
	device_name = "/dev/sdb"
    volume_type = "gp2"
	volume_size ="15"
	encrypted = "true"
}
ebs_block_device {
      device_name = "/dev/sdc"
      volume_type = "gp2"
      volume_size = "20"
      encrypted = "true"
}
}
