//environment_name = "staging"

# AWS
vpc_id = "vpc-0c686b68"
asg_min_size = "2"
asg_max_size = "2"
ecs_service_task_desired_count = "2"
deployment_maximum_percent = "100"
deployment_minimum_healthy_percent = "50"

//ec2_instance_type = "m3.medium"
ec2_instance_root_volume_size = "16"
ec2_instance_root_volume_type = "gp2"

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

# Datadog
//datadog_api_key = "3627b92bb769363df61f31911415bccf"
//datadog_app_key = "499b445d14ecb479a4af641947c33ef14c045cb4"

subnet_ids = {
  "us-east-1b,us-east-1c" = "subnet-2e8e3104,subnet-554e2023"
}

route53_zone_id = "Z20LPUPJN34JT6"

//service_domain = "chasopys.spock.dev.smartling.net"

//
//db_host_domain = "estimation-db.spock.dev.smartling.net"
//rabbitmq_host = "stg-pmq1.aws"
//rabbitmq_username = "smartling"
//rabbitmq_password = "Legander13_Xpat"
//ecs_service_post_deploy_validation = "1"
//spring_profiles_active = "aws,background,system-test"