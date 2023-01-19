resource "aws_iam_role" "iam_role_for_lambda" {
  name = "${var.project_name}-${var.environment}-iam-role-for-lambda-test"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
          ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "${var.project_name}-${var.environment}-lambda-test-policy"
  description = ""

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt",
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "*"

    }
  ]
}
EOF
}
# "arn:aws:s3:::my-cloudtrail-bucket/*"

resource "aws_iam_role_policy_attachment" "lambda-policy-attach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}

data "aws_partition" "current" {}

data "aws_iam_policy" "AWSLambdaVPCAccessExecutionRole" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy" "AmazonElasticFileSystemClientFullAccessRole" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole-attach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "AmazonElasticFileSystemClientFullAccess-attach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = data.aws_iam_policy.AmazonElasticFileSystemClientFullAccessRole.arn
}
