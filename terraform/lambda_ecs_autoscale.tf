# This terraform config defines AWS Lambda function that is used to sync ASG scaling with ECS.
# Template that contains body of AWS Lambda function.
data "template_file" "ecs_autoscale_lambda_template" {
  template = "${file("files/lambda_ecs_autoscale.js.tmpl")}"
  vars {
    ecs_service_name = "${aws_ecs_service.ecs_service.name}"
    ecs_cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
    asg_name = "${aws_autoscaling_group.autoscaling_group.name}"
  }
}

# Here we're using workaround to render template into local file.
# Current version of terraform 0.6.12 doesn't allow to do it,
# check this issue: https://github.com/hashicorp/terraform/issues/2342
#
# WARNING: this workaround works in Linux and OS X only, not Windows.
resource "null_resource" "ecs_autoscale_lambda_template_rendered_file" {
  triggers { template = "${data.template_file.ecs_autoscale_lambda_template.rendered}" }
  provisioner "local-exec" {
    command = "cat <<FILEXXX > files/lambdas/ecs_autoscale/lambda_ecs_autoscale.js\n${data.template_file.ecs_autoscale_lambda_template.rendered}\nFILEXXX"
  }
}

# Here we're creating zip file with AWS Lambda function body
resource "null_resource" "ecs_autoscale_lambda_template_zip" {
  triggers { template = "${data.template_file.ecs_autoscale_lambda_template.rendered}" }
  depends_on = [ "null_resource.ecs_autoscale_lambda_template_rendered_file" ]
  provisioner "local-exec" {
    command = "cd files/lambdas/ecs_autoscale && zip ../ecs_autoscale.zip *"
  }
}

# AWS Lambda function to sync ASG scaling with ECS.
resource "aws_lambda_function" "ecs_autoscale_lambda" {
  depends_on = [ "null_resource.ecs_autoscale_lambda_template_zip" ]
  filename = "files/lambdas/ecs_autoscale.zip"
  function_name = "tf-${var.service_name}-${var.environment_name}_ecs_autoscale"
  role = "${aws_iam_role.iam_role.arn}"
  runtime = "nodejs4.3"
  timeout = "8"
  handler = "lambda_ecs_autoscale.handler"
}

# IAM permission that is required to invoke AWS Lambda function from SNS
resource "aws_lambda_permission" "ecs_autoscale_lambda_sns_permission" {
  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ecs_autoscale_lambda.arn}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.scale_notifications.arn}"
}

# AWS Lambda is subsribed to SNS topic so events that come to it will be processed by Lambda.
resource "aws_sns_topic_subscription" "scale_sns_events" {
  topic_arn = "${aws_sns_topic.scale_notifications.arn}"
  protocol = "lambda"
  endpoint  = "${aws_lambda_function.ecs_autoscale_lambda.arn}"
}
