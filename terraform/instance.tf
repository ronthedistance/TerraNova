resource "aws_instance" "public" {

        ami = "ami-06d51e91cea0dac8d"
        instance_type = "t2.micro"
        associate_public_ip_address = true

        vpc_security_group_ids = ["${aws_security_group.public-security-group.id}"]
        subnet_id = "${aws_subnet.project1-public-subnet1.id}"

        key_name = "chococat"

        user_data = "${file("install_ansible.sh")}"

        tags = {
                Name = "public"
        }

}

resource "aws_instance" "private" {

        ami = "ami-06d51e91cea0dac8d"
        instance_type = "t2.micro"


        vpc_security_group_ids = ["${aws_security_group.private-security-group.id}"]
        subnet_id = "${aws_subnet.project1-private-subnet1.id}"

        tags = {
                Name = "blog-1"
        }

        key_name = "chococat"

        user_data = "${file("install_ansible.sh")}"

}


resource "aws_instance" "private2" {

        ami = "ami-06d51e91cea0dac8d"
        instance_type = "t2.micro"


        vpc_security_group_ids = ["${aws_security_group.private-security-group.id}"]
        subnet_id = "${aws_subnet.project1-private-subnet1.id}"

        tags = {
                Name = "blog-2"
        }

        key_name = "chococat"


        user_data = "${file("install_ansible.sh")}"
}