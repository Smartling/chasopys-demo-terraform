# VPC EC2 Security Group that will be used by EC2 instances, ELBs and RDS instances
resource "aws_security_group" "ecs_security_group" {
  name = "tf-${var.service_name}-${var.environment_name}"
  description = "SG for EC2 instances which run ${var.service_name} in ${var.environment_name} env."

  # Access to SG from VPN
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ "${var.vpn_server_security_group_id}" ]
  }

  # Access within Security Group via TCP
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  # Egress connections to Internet from Security Group
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  vpc_id = "${var.vpc_id}"
}
