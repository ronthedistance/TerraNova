resource "aws_instance" "public" {

        ami = "ami-06d51e91cea0dac8d"
        instance_type = "t2.micro"
        associate_public_ip_address = true

        vpc_security_group_ids = ["sg-0c4f191bcd7b245d7"]
        subnet_id = "subnet-0eec952ee97f8519b"

        tags = {
                Name = "public"
        }

        key_name = "chococat"
}

resource "aws_instance" "private" {

        ami = "ami-06d51e91cea0dac8d"
        instance_type = "t2.micro"


        vpc_security_group_ids = ["sg-0eb48eee9c012fa74"]
        subnet_id = "subnet-0573058e22f3239d8"

        tags = {
                Name = "blog"
        }

        key_name = "chococat"
}