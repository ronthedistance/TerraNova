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