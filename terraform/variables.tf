variable "username" {
        type = "list"
        default = ["darren","ron","marcin"]
}

variable "iam_policy_arn" {
        type = "list"
        default = [
                "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
                "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
                "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
                "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
        ]
}