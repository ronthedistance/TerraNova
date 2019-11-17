resource "aws_acm_certificate" "main" {
  domain_name = "downtimerus.net"
  subject_alternative_names = ["*.downtimerus.net"]
  validation_method = "DNS"
}

data "aws_route53_zone" "validation" {
  name = "downtimerus.net."
}

resource "aws_route53_record" "validation" {
  name = "${aws_acm_certificate.main.domain_validation_options[0].resource_record_name}"
  type = "${aws_acm_certificate.main.domain_validation_options[0].resource_record_type}"
  zone_id = "${data.aws_route53_zone.validation.zone_id}"
  records = ["${aws_acm_certificate.main.domain_validation_options[0].resource_record_value}"]
  ttl = 300
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = "${aws_acm_certificate.main.arn}"
  validation_record_fqdns = "${aws_route53_record.validation.*.fqdn}"
}
