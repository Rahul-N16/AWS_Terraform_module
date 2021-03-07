#! /bin/bash
sudo mkdir /apps 
sudo mkdir /logs
sudo mount /dev/sdb /apps
sudo mount /dev/sdc /logs
sudo yum update
sudo yum install -y httpd
sudo chkconfig httpd on
sudo service httpd start

Host=`hostname`; echo "<h1>Web Server deployed via Terraform with VPC, ELB and ASG in $Host </h1>" | sudo tee /var/www/html/index.html
