# ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "tf-${var.service_name}-${var.environment_name}"
  lifecycle { create_before_destroy = true }
}

# ECS Task definition
resource "aws_ecs_task_definition" "task_def" {
  family = "tf-${var.service_name}-${var.environment_name}"
  container_definitions = "${data.template_file.service_task_def_containers_template.rendered}"

  volume {
    name = "logs-dir"
  }

  volume {
    name = "docker-socket"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name = "docker-datadir"
    host_path = "/var/lib/docker"
  }
}

# ECS service
resource "aws_ecs_service" "ecs_service" {

  name = "tf-${var.service_name}-${var.environment_name}"
  cluster = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.task_def.arn}"
  iam_role = "${aws_iam_role.iam_role.arn}"

  # Number of service nodes to run.
  desired_count = "2"

  # Minimum percentage of healthy hosts remaining up during deployment.
  deployment_minimum_healthy_percent = "50"

  # Maximum percentage of hosts that is up during deployment.
  deployment_maximum_percent = "100"

  load_balancer {
    elb_name = "${aws_elb.service_elb.id}"
    container_name = "chasopys-demo"
    container_port = 8443
  }

  lifecycle {
    ignore_changes = [ "desired_count" ]
    create_before_destroy = true
  }
}

data "template_file" "service_task_def_containers_template" {
  template = "${file("files/containers.json.tmpl")}"
  vars {
    docker_registry = "${var.docker_registry}"
    git_commit = "${var.git_commit}"
    deploy_unix_time = "${var.deploy_unix_time}"
  }
}

