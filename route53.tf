data "aws_route53_zone" "primary" {
  name = "downtimerus.net."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "downtimerus.net"
  type    = "A"

  alias {
    name                   = "${aws_elb.main.dns_name}"
    zone_id                = "${aws_elb.main.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cname" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "www.downtimerus.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["downtimerus.net"]
}
