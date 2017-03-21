# SNS topic for communication between Autoscale group and Lambda functions
resource "aws_sns_topic" "scale_notifications" {
  name = "tf-${var.service_name}-autoscale-${var.environment_name}"
}

# SNS topic for notifications to service owner team e.g. via email or pagerduty
resource "aws_sns_topic" "notifications" {
  name = "tf-${var.service_name}-notifications-${var.environment_name}"
}
