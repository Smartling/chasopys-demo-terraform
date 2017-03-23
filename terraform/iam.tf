# IAM role that will be used by EC2 instances, ECS services, Lambda functions
resource "aws_iam_role" "iam_role" {
    name = "tf-${var.service_name}-${var.environment_name}"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "estimation_service_s3_policy" {
  name = "tf-chasopys-demo-s3-policy"
  role = "${aws_iam_role.iam_role.id}"
  policy = <<EOF
{
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": "arn:aws:s3:::*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "estimation_list_aliases_policy" {
  name = "tf-estimation-list-aliases-policy"
  role = "${aws_iam_role.iam_role.id}"
  policy = <<EOF
{
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [ "iam:ListAccountAliases" ],
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "estimation_service_rds_backup_iam_policy" {
  name = "tf-chasopys-demo-rds-backup-policy"
  role = "${aws_iam_role.iam_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:ListTagsForResource",
                "rds:CopyDBSnapshot",
                "rds:CreateDBSnapshot",
                "rds:DeleteDBSnapshot",
                "rds:DescribeDBSnapshots",
                "rds:DescribeEventCategories",
                "rds:DescribeEvents"
            ],
            "Resource": "arn:aws:rds:*"
        },
        {
          "Effect": "Allow",
          "Action": [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
          ],
          "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBSnapshots"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "tf-${var.service_name}-${var.environment_name}"

  roles = ["${aws_iam_role.iam_role.name}"]
}

data "template_file" "ecs_policy_template" {
  template = "${file("files/iam_ecs_policy.tmpl")}"
  vars = {
    ecs_cluster_arn = "${aws_ecs_cluster.ecs_cluster.id}"
    autoscale_sns_topic_arn = "${aws_sns_topic.scale_notifications.arn}"
    notifs_sns_topic_arn = "${aws_sns_topic.notifications.arn}"
  }
}

resource "aws_iam_role_policy" "iam_ecs_policy" {
  name = "ecs-policy"
  role = "${aws_iam_role.iam_role.id}"
  policy = "${data.template_file.ecs_policy_template.rendered}"
}

resource "aws_iam_user" "deployer" {
    name = "tf-${var.service_name}-${var.environment_name}-deployer"
    path = "/"
}
