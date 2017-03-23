resource "aws_route53_record" "service_route" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.service_domain}" //chasopys.spock.dev.smartling.net
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.service_elb.dns_name}"]
}