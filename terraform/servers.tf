data "aws_ami" "ubuntu" {
  most_recent = true # if multiple results come back from AMI search, use most recent

  # search filters for image
  filter {
    name   = "name"                                                       # name filter
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type" # virtualization type filter
    values = ["hvm"]
  }

  # owner of the image 'Canonical' in this case that distributes ubuntu
  owners = ["099720109477"]
}

# EC2 instance as app server
resource "aws_instance" "project1-app" {
  # take result from 'data' block above and assign to ami property of instance
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "project1_app"
  }

  # assign this instance to public subnet created in resources.tf file
  subnet_id = "${aws_subnet.project1-public-subnet.id}"

  # assign public IP automatically
  associate_public_ip_address = true

  # associate elastic IP (optional)

  # specify private key (assuming key was previously created)
  key_name = "project1"
  # associate previously made security group with instance
  vpc_security_group_ids = ["${aws_security_group.public-security-group.id}"]
}

# EC2 instance for database
resource "aws_instance" "project1-database" {
  # take result from 'data' block above and assign to ami property of instance
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "project1_database"
  }

  # assign this instance to private subnet created in resources.tf file
  subnet_id = "${aws_subnet.project1-private-subnet.id}"

  # no public IP for this instance

  # specify private key (assuming key was previously created)
  key_name = "project1"
  # associate previously made security group with instance
  vpc_security_group_ids = ["${aws_security_group.private-security-group.id}"]
}
