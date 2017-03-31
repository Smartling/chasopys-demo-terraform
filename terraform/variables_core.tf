variable "service_name" {
  description = "Short name of service that is going to be deployed by this terraform configuration e.g. myservice."
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
  default = "-1"
  description = "VPC Id in which to create AWS resources like Ec2 instances, ELBs etc."
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

variable "elb_cert_id" {
  description = "IAM Certificate id for ELB."
}

variable "route53_zone_id" {
  default = "-1"
}

variable "deploy_unix_time" {
  default = "-1"
}

variable "ami_id" {
  default = "ami-e06e8e8d"
}