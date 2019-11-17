# Create IAM users
resource "aws_iam_user" "users" {
        count = "${length(var.username)}"
        name = "${element(var.username,count.index)}"
}

# Create IAM Group
resource "aws_iam_group" "group" {
        name = "DropTables"
}

# Attach AWS Policy to Group
resource "aws_iam_group_policy_attachment" "policy" {
        group = "${aws_iam_group.group.name}"
        count = "${length(var.iam_policy_arn)}"
        policy_arn = "${var.iam_policy_arn[count.index]}"
}

# Assign IAM Group
resource "aws_iam_group_membership" "team" {
        name = "group-membership"
        users = ["ron","marcin","darren","genna"]
        group = "${aws_iam_group.group.name}"
}

# For Ron's Lambda
resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
 "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}
