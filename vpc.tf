# VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block       = var.vpc_cidr
  tags =  {
    Name = "TerraVPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id
  tags =  {
    Name = "main"
  }
}

# Subnets : public
resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.terra_vpc.id
  cidr_block = element(var.public_subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags =  {
    Name = "Public-Subnet-${count.index+1}"
  }
}

# Subnets : private
resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.terra_vpc.id
  cidr_block = element(var.private_subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  tags =  {
    Name = "Private-Subnet-${count.index+1}"
  }
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "Nat-Gateway-EIP" {
  count = "2"
  depends_on = [
    aws_route_table_association.public
  ]
  vpc = true
}


# Creating a NAT Gateway!
resource "aws_nat_gateway" "webserver_NAT" {
 count = length(var.public_subnets_cidr)
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]
  allocation_id = element(aws_eip.Nat-Gateway-EIP.*.id,count.index)
  subnet_id = element(aws_subnet.public.*.id,count.index)
  tags = {
    Name = "Nat-Gateway_Project"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terra_vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags =  {
    Name = "publicRouteTable"
  }
}

# Route table : attach NAT Gateway
resource "aws_route_table" "private_rt" {
  count = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.terra_vpc.id
  route {
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.webserver_NAT.*.id, count.index)  
}	  
  tags =  {
    Name = "privateRouteTable"
  }
}

#Route table association with public subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id
}

# Route table association with private subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id,count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

