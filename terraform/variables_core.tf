variable "service_name" {
  description = "Short name of service that is going to be deployed by this terraform configuration e.g. myservice."
  default = "chasopys-demo"
}

variable "service_tag" {
  description = "Full service name used for tagging"
  default = "chasopys-demo"
}

variable "environment_name" {
  default = "dev"
  description = "Environment name to name and tag AWS resources (tag=environment)"
}

variable "aws_region" {
  default = "us-east-1"
  description = "AWS region for infrastructure."
}

variable "vpc_id" {
  default = "vpc-0c686b68"
  description = "VPC Id in which to create AWS resources like Ec2 instances, ELBs etc."
}

variable "asg_min_size" {
  description = "Minimum number of instances to run in Autoscaling group"
  default = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances to run in the Autoscaling group"
  default = 1
}

variable "git_commit" {
  description = "My service git commit that should be deployed."
  default = "commithash1"
}

variable "subnet_ids" {
  type = "map"

  //must be replaced with values from tfvars file
  default = {
    "us-east-1b" = "-1"
    "us-east-1c" = "-1"
    "us-east-1b,us-east-1c" = "-1,-1"
  }

  description = "Comma separated list of subnet ids in which to create AWS resources like ELBs, Ec2 instances."
}

variable "ec2_instance_type" {
  description = "Name of the AWS instance type"
  default = "t2.small"
}

variable "ec2_instance_root_volume_size" {
  description = "Size of EBS root volume for EC2 instances."
  default = "16"
}

variable "ec2_instance_root_volume_type" {
  description = "Type of EBS root volume for EC2 instances."
  default = "gp2"
}

variable "asg_healthcheck_grace_period" {
  default = "300"
  description = "Time after instance comes into service before checking health"
}

variable "availability_zones" {
  description = "Comma separated list of EC2 availability zones to launch instances."
  default = "us-east-1d,us-east-1e,us-east-1c,us-east-1a"
}

variable "vpn_server_security_group_id" {
  description = "Smartling VPN server security group ID." ###
}

variable "docker_registry" {
  description = "Docker registry URL e.g. docker-registry.domain.ltd"
}

variable "docker_cleanup_interval_seconds" {
  default = 10800
  description = "Interval for docker containers and volumes cleanup."
}

variable "elb_cert_id" {
  description = "IAM Certificate id for ELB."
}

variable "elb_health_check_url" {
  description = "Relative URL for ELB health checks."
  default = "/health"
}

variable "asg_healthcheck_type" {
  default = "EC2"
  description = "Type of health check for ASG: EC2 or ELB. See documentation for more details."
}

variable "deployment_minimum_healthy_percent" {
  default = "50"
  description = "Minimum percentage of healthy hosts remaining up during deployment."
}

variable "deployment_maximum_percent" {
  default = "200"
  description = "Minimum percentage of hosts that is up during deployment."
}

variable "ecs_service_task_desired_count" {
  default = "2"
  description = "Number of service nodes to run."
}

variable "route53_zone_id" {
  default = "-1"
}

variable "deploy_unix_time" {
  default = "-1"
}

variable "service_domain" {
  default = "chasopys.spock.dev.smartling.net"
}

variable "ami_id" {
  default = "ami-23000434" # Smartling SOA AMI
}