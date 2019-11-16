resource "aws_elb" "main" {
  name               = "elastic-lb"
  availability_zones = ["us-west-2b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
    listener {
    instance_port     = 443
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "http"
    ssl_certificate_id = "${aws_acm_certificate.main.arn}"
  }
  
    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  
    #instances                   = ["${aws_instance.public.id}"]
    instances                   = ["i-0f09bd763f961f3b1"]
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400
}
