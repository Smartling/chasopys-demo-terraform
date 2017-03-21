# Uncomment below lines in case service requires MySQL database with persistent storage

variable "database_user" {
  description = "Db user name"
  default = "admin"
}

variable "database_name" {
  description = "Db name"
  default = "estimation_service"
}

variable "backup_retention_period" {
  description = "For how many days backups should be stored"
}

variable "rds_snapshot_id" {
  default = ""
  description = "RDS snapshot id to create RDS instance e.g. rds:db-2016-03-03-09-09. If value is empty, empty DB will be created."
}

variable "rds_subnet_group" {
  default = "private"
  description = "RDS subnet group for RDS db instance."
}

variable "rds_multiaz" {
  description = "MultiAZ feature for RDS."
}

variable "rds_password_estimation_service" {
  description = "Master password for RDS db instance."
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS instance in Gigabytes."
}

variable "rds_instance_class" {
  description = "RDS DB Instance class."
}

variable "skip_final_snapshot" {
  default = "true"
  description = "Set this variable to true if you wish to skip final snapshot when DB instance is deleted."
}

resource "aws_db_parameter_group" "rds_parameters_group" {
    name = "tf-${var.service_name}-${var.environment_name}-params"
    family = "mysql5.6"
    description = "RDS parameter group for ${var.service_name} service in ${var.environment_name}"

    parameter {
      name = "character_set_server"
      value = "utf8mb4"
    }
    parameter {
      name = "collation_connection"
      value = "utf8mb4_general_ci"
    }
    parameter {
      name = "collation_server"
      value = "utf8mb4_general_ci"
    }

    parameter {
      name = "log_bin_trust_function_creators"
      value = "1"
    }
}

# Please notice that sha1 of rds_snapshot_id is specified in db identifier, this is
# done for possibility to create new database instance from snapshot -- just change
# value of rds_snapshot_id and do terraform apply to re-create database instance.

resource "aws_db_instance" "db_instance" {
  identifier = "${var.environment_name}-${var.service_name}-${md5(var.rds_snapshot_id)}"

  snapshot_identifier = "${var.rds_snapshot_id}"

  allocated_storage = "${var.rds_allocated_storage}"
  storage_type = "gp2"
  instance_class = "${var.rds_instance_class}"

  multi_az = "${var.rds_multiaz}"
  engine = "mysql"
  engine_version = "5.6.27"
  name = "${var.database_name}"
  username = "${var.database_user}"
  password = "${var.rds_password_estimation_service}"

  db_subnet_group_name = "${var.rds_subnet_group}"
  parameter_group_name = "${aws_db_parameter_group.rds_parameters_group.id}"
  vpc_security_group_ids = [ "${aws_security_group.ecs_security_group.id}" ]

  skip_final_snapshot = "${var.skip_final_snapshot}"

  backup_retention_period = "${var.backup_retention_period}"

  tags {
    Service = "${var.service_name}"
    Environment = "${var.environment_name}"
  }
}

resource "aws_db_event_subscription" "event_subscription" {
  name = "tf-${var.service_name}-${var.environment_name}-events"
  sns_topic = "${aws_sns_topic.notifications.arn}"
}

resource "aws_cloudwatch_metric_alarm" "db_instance_high_cpu_load" {
  alarm_name = "tf-${var.service_name}-${var.environment_name}-rds-high-cpu-load"
  alarm_description = "Alarm is triggered when there is high CPU Load at RDS db instance used by ${var.service_name} service in ${var.environment_name}."

  metric_name = "CPUUtilization"
  namespace = "AWS/RDS"
  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.db_instance.id}"
  }
  statistic = "Average"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "3"

  period = 60
  threshold = 75

  alarm_actions = [ "${aws_sns_topic.notifications.arn}" ]
  ok_actions = [ "${aws_sns_topic.notifications.arn}" ]
  insufficient_data_actions = [ "${aws_sns_topic.notifications.arn}" ]
}

resource "aws_cloudwatch_metric_alarm" "db_instance_low_disk" {
  alarm_name = "tf-${var.service_name}-${var.environment_name}-low-disk"
  alarm_description = "Alarm is triggered when there is low free disk space at RDS db instance used by ${var.service_name} service in ${var.environment_name}."

  metric_name = "FreeStorageSpace"
  namespace = "AWS/RDS"
  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.db_instance.id}"
  }
  statistic = "Average"

  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "3"

  period = 60
  threshold = 2147483648 # 2 GB in Bytes

  alarm_actions = [ "${aws_sns_topic.notifications.arn}" ]
  ok_actions = [ "${aws_sns_topic.notifications.arn}" ]
  insufficient_data_actions = [ "${aws_sns_topic.notifications.arn}" ]
}

