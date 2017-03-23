# Elastic Load Balancer that will accept traffic for service
resource "aws_elb" "service_elb" {
  name = "tf-${var.service_name}-${var.environment_name}"
  subnets = ["${split(",", lookup(var.subnet_ids, var.availability_zones))}"]
  security_groups = [ "${aws_security_group.ecs_security_group.id}" ]
  cross_zone_load_balancing = true
  internal = true
  idle_timeout = 300
  connection_draining = true
  connection_draining_timeout = 120

  listener {
    instance_port = 443
    instance_protocol = "https"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.elb_cert_id}"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 15
    target = "HTTPS:443/health"
    interval = 20
  }

}
