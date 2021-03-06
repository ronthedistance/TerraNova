provider "aws" {
  region                  = "us-west-2"
}


# create a VPC
resource "aws_vpc" "project1-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "project1_vpc"
  }
}

# create public subnet

resource "aws_subnet" "project1-public-subnet1" {
  cidr_block        = "172.16.0.0/22"
  vpc_id            = "${aws_vpc.project1-vpc.id}"
  availability_zone = "us-west-2a"

  tags = {
    Name = "project1_subnet_public1"
  }
}

resource "aws_subnet" "project1-public-subnet2" {
  cidr_block        = "172.16.4.0/22"
  vpc_id            = "${aws_vpc.project1-vpc.id}"
  availability_zone = "us-west-2b"

  tags = {
    Name = "project1_subnet_public2"
  }
}

resource "aws_subnet" "project1-public-subnet3" {
  cidr_block        = "172.16.8.0/22"
  vpc_id            = "${aws_vpc.project1-vpc.id}"
  availability_zone = "us-west-2c"

  tags = {
    Name = "project1_subnet_public3"
  }
}

# create private subnet
resource "aws_subnet" "project1-private-subnet1" {
  cidr_block        = "172.16.16.0/20"
  vpc_id            = "${aws_vpc.project1-vpc.id}"
  availability_zone = "us-west-2a"

  tags = {
    Name = "project1_subnet_private1"
  }
}

# create private subnet
resource "aws_subnet" "project1-private-subnet2" {
  cidr_block        = "172.16.32.0/20"
  vpc_id            = "${aws_vpc.project1-vpc.id}"
  availability_zone = "us-west-2b"

  tags = {
    Name = "project1_subnet_private2"
  }
}

# create private subnet
resource "aws_subnet" "project1-private-subnet3" {
  cidr_block        = "172.16.48.0/20"
  vpc_id            = "${aws_vpc.project1-vpc.id}"
  availability_zone = "us-west-2c"

  tags = {
    Name = "project1_subnet_private"
  }
}



# provision internet gateway and attach to VPC
resource "aws_internet_gateway" "project1-gateway" {
  vpc_id = "${aws_vpc.project1-vpc.id}"

  tags = {
    Name = "project1_gateway"
  }
}

# change route table associated with public subnet (1 route table created by default with VPC i think)
#...or create one
resource "aws_route_table" "project1-public-route-table" {
  vpc_id = "${aws_vpc.project1-vpc.id}"

  # Note that the default route, mapping the VPC's CIDR block to "local", is created implicitly and cannot be specified.
  # cidr_block = "10.0.0.0/16" is implied

  route {
    # destination
    cidr_block = "0.0.0.0/0"

    # target
    gateway_id = "${aws_internet_gateway.project1-gateway.id}"
  }
  tags = {
    Name = "project1_public_route_table"
  }
}

# associate a subnet with the route table (public subnet in this case)
resource "aws_route_table_association" "route-table-association-public1" {
  subnet_id      = "${aws_subnet.project1-public-subnet1.id}"
  route_table_id = "${aws_route_table.project1-public-route-table.id}"
}
resource "aws_route_table_association" "route-table-association-public2" {
  subnet_id      = "${aws_subnet.project1-public-subnet2.id}"
  route_table_id = "${aws_route_table.project1-public-route-table.id}"
}
resource "aws_route_table_association" "route-table-association-public3" {
  subnet_id      = "${aws_subnet.project1-public-subnet3.id}"
  route_table_id = "${aws_route_table.project1-public-route-table.id}"
}

# set the main route table for VPC
resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.project1-vpc.id}"
  route_table_id = "${aws_route_table.project1-public-route-table.id}"
}

# create security group for public EC2 Instance
resource "aws_security_group" "public-security-group" {
  name        = "public_group"              # 'group name' column
  description = "Allow SSH inbound traffic"
  vpc_id      = "${aws_vpc.project1-vpc.id}"

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS inbound
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    #DNS Traffic
    ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ssh outbound to be able to connect to private subnet
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS outbound
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for DNS lookups
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_security_group" # 'security group name' column
  }
}

# create security group for private EC2 Instance
resource "aws_security_group" "private-security-group" {
  name        = "private_group"             # 'group name' column
  description = "Allow SSH inbound traffic"
  vpc_id      = "${aws_vpc.project1-vpc.id}"

  # only allow incoming ssh
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # cidr_blocks = ["0.0.0.0/0"] # no CIDR block, specify subnet instead
    # Allow incoming connections only from public subnet
    security_groups = ["${aws_security_group.public-security-group.id}"]
  }
  #
  # HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_security_group" # 'security group name' column
  }
}

# provision NAT ec2 instance (or gateway)

# First, get an elastic IP to associate with gateway
resource "aws_eip" "gateway-elastic-ip" {
  vpc = true
}

# provision NAT gateway
resource "aws_nat_gateway" "nat-gateway" {
  subnet_id     = "${aws_subnet.project1-public-subnet1.id}" # subnet should be public subnet
  allocation_id = "${aws_eip.gateway-elastic-ip.id}"    # must have an elastic IP associated

  tags = {
    Name = "NAT Gateway"
  }
}

# create another route table associated with private subnet this time
resource "aws_route_table" "project1-private-route-table" {
  vpc_id = "${aws_vpc.project1-vpc.id}"

  # Note that the default route, mapping the VPC's CIDR block to "local", is created implicitly and cannot be specified.
  # cidr_block = "172.16.0.0/16" is implied

  route {
    # destination
    cidr_block = "0.0.0.0/0"

    # target will be NAT gateway instead of internet gateway
    gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }
  tags = {
    Name = "project1_private_route_table"
  }
}

# associate new route table with private subnet
resource "aws_route_table_association" "route-table-association-private1" {
  subnet_id      = "${aws_subnet.project1-private-subnet1.id}"
  route_table_id = "${aws_route_table.project1-private-route-table.id}"
}
resource "aws_route_table_association" "route-table-association-private2" {
  subnet_id      = "${aws_subnet.project1-private-subnet2.id}"
  route_table_id = "${aws_route_table.project1-private-route-table.id}"
}

resource "aws_route_table_association" "route-table-association-private3" {
  subnet_id      = "${aws_subnet.project1-private-subnet3.id}"
  route_table_id = "${aws_route_table.project1-private-route-table.id}"
}
