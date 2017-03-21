# Autoscaling group (ASG) for service
resource "aws_autoscaling_group" "autoscaling_group" {
  name = "tf-${var.service_name}-${var.environment_name}"
  availability_zones = ["${split(",", var.availability_zones)}"]
  depends_on = [ "aws_launch_configuration.ecs_cluster_asg_launch_config" ]
  vpc_zone_identifier = ["${split(",", lookup(var.subnet_ids, var.availability_zones))}"]
  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  launch_configuration = "${aws_launch_configuration.ecs_cluster_asg_launch_config.name}"

  health_check_grace_period = "${var.asg_healthcheck_grace_period}"
  health_check_type = "${var.asg_healthcheck_type}"

  load_balancers = ["${split(",", aws_elb.service_elb.id)}"]

  lifecycle { create_before_destroy = true }

  tag {
    key = "Environment"
    value = "${var.environment_name}"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value =  "tf-${var.service_name}-ecs-${var.environment_name}"
    propagate_at_launch = true
  }
}

# ASG launch configuration that defines instances launched by autoscaling group
resource "aws_launch_configuration" "ecs_cluster_asg_launch_config" {
  name_prefix = "tf-${var.service_name}-${var.environment_name}-"
  image_id = "${var.ami_id}"
  instance_type = "${var.ec2_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.id}"
  security_groups = ["${aws_security_group.ecs_security_group.id}"]

  root_block_device {
    volume_type = "${var.ec2_instance_root_volume_type}"
    volume_size = "${var.ec2_instance_root_volume_size}"
  }

  associate_public_ip_address = false
  user_data = "${data.template_file.launch_configuration_userdata.rendered}"
  lifecycle { create_before_destroy = true }
}

data "template_file" "launch_configuration_userdata" {
  template = "${file("files/launch_configuration_userdata.tmpl")}"
  vars {
    ecs_cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
    ecs_cleanup_interval_seconds = "${var.docker_cleanup_interval_seconds}"
    environment_name = "${var.environment_name}"
    service_name = "${var.service_name}"
    service_tag = "${var.service_tag}"
  }
}

resource "aws_autoscaling_notification" "ecs_asg_up_notifications" {
  group_names = [
    "${aws_autoscaling_group.autoscaling_group.name}"
  ]
  notifications  = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE"
  ]
  topic_arn = "${aws_sns_topic.scale_notifications.arn}"
}

resource "aws_autoscaling_policy" "autoscale_group_policy_up_x1" {
  name = "autoscale_group_policy_up_x1"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling_group.name}"
}

resource "aws_autoscaling_policy" "autoscale_group_policy_down_x1" {
  name = "autoscale_group_policy_down_x1"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling_group.name}"
}

resource "aws_cloudwatch_metric_alarm" "elb_high_requests_count_high" {
    alarm_name = "tf-${var.service_name}-ELB-RequestNumber-High-${var.environment_name}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "RequestCount"
    namespace = "AWS/ELB"
    period = "60"
    statistic = "Sum"
    threshold = "2000"
    alarm_description = "This alarm triggers when requests count for ELB is high."
    alarm_actions = [
      "${aws_sns_topic.scale_notifications.arn}",
      "${aws_autoscaling_policy.autoscale_group_policy_up_x1.arn}"
    ]
    insufficient_data_actions = [ "${aws_sns_topic.notifications.arn}" ]
    dimensions {
      LoadBalancerName = "${aws_elb.service_elb.id}"
    }
}

resource "aws_cloudwatch_metric_alarm" "elb_high_requests_count_low" {
    alarm_name = "tf-${var.service_name}-ELB-RequestNumber-Low-${var.environment_name}"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "RequestCount"
    namespace = "AWS/ELB"
    period = "60"
    statistic = "Sum"
    threshold = "50"
    alarm_description = "This alarm triggers when requests count for ELB is low."
    alarm_actions = [
      "${aws_sns_topic.scale_notifications.arn}",
      "${aws_autoscaling_policy.autoscale_group_policy_down_x1.arn}"
    ]
    dimensions {
      LoadBalancerName = "${aws_elb.service_elb.id}"
    }
}
