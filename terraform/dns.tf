resource "aws_route53_record" "service_route" {
  zone_id = "${var.route53_zone_id}"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.service_elb.dns_name}"]

  name = "chasopys-demo1.spock.dev.smartling.net"
}