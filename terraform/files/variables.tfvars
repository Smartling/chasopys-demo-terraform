//environment_name = "staging"

# AWS
vpc_id = "vpc-0c686b68"

availability_zones = "us-east-1b,us-east-1c"

//eureka_dns_name = "eureka.smartling.staging"
docker_registry = "docker-registry-v2.smartling.net"

//api_gateway_security_group_id = "373682980683/sg-8c224ceb"
vpn_server_security_group_id = "373682980683/sg-a11f81d9"

elb_cert_id = "arn:aws:acm:us-east-1:317743842067:certificate/6a66aeeb-fe0a-4f17-b3ce-a9d1bdc3c751"

//rds_instance_class = "db.t2.small"
//rds_multiaz = "false"
//rds_allocated_storage = "16"
//backup_retention_period = "3"

tf_configuration_storage_bucket = "sl-chasopys-demo-config-staging"

subnet_ids = {
  "us-east-1b,us-east-1c" = "subnet-2e8e3104,subnet-554e2023"
}

route53_zone_id = "Z20LPUPJN34JT6"
