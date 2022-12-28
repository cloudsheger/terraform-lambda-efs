resource "aws_iam_role" "lambda_example" {
  name = var.lambda_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_example" {
  role       = aws_iam_role.lambda_example.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}