locals {
  lambda_dir            = "${path.module}/${var.lambda_root}"
}

data "archive_file" "lambda_source" {
  source_dir  = "${path.module}/${var.lambda_root}"
  output_path = "${local.lambda_dir}/${random_uuid.lambda_src_hash.result}.zip"
  type        = "zip"

  depends_on  = [null_resource.install_dependencies]
  excludes    = [
    "__pycache__",
    "venv",
    "package",
  ]
}

#######################################################
#### IAM Role data definition
######################################################

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "sts:AssumeRole"]
  }
}


data "aws_partition" "current" {}

data "aws_iam_policy" "AWSLambdaVPCAccessExecutionRole" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy" "AmazonElasticFileSystemClientFullAccessRole" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
}
