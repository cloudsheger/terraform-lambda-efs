provider "aws" {
  region = var.aws_region
}

data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/example/dist"
output_path = "${path.module}/example/dist/function.zip"
}

module "lambda" {
  source = "./modules/lambda"

  name = "${var.stage}-${var.name}-function"

  deployment_package = "${path.module}/example/dist/function.zip"
  handler = var.handler
  runtime = var.runtime
  timeout = var.timeout
  memory_size = var.memory_size

  #iam_role_for_lambda = module.iam.iam_role_for_lambda.arn
  iam_role_for_lambda = aws_iam_role.iam_role_for_lambda.arn
  subnet_ids = [data.aws_subnet.this.id]
  security_groups_ids = [data.aws_security_group.this.id]
  efs_access_point_arn = module.efs.access_point_arn
  efs_mount_targets = module.efs.mount_targets

  local_mount_path = var.local_mount_path

  depends_on = [aws_iam_role_policy_attachment.AWSLambdaVPCAccessExecutionRole-attach,
                aws_iam_role_policy_attachment.AmazonElasticFileSystemClientFullAccess-attach
               ]  
}

module "efs" {
  source = "./modules/efs"

  name = "${var.stage}-${var.name}-efs"
  subnet_ids = [data.aws_subnet.this.id]
  security_group_ids = [data.aws_security_group.this.id]
  provisioned_throughput = var.efs_provisioned_throughput
  throughput_mode = var.efs_throughput_mode
}

data "aws_vpc" "this" {
  tags = {
    Name = "cloudcasts-staging-vpc"

  }
}

data "aws_subnet" "this" {
  tags = {
    Name   = "cloudcasts-staging-public-subnet"
    Subnet = "us-east-1c-3"
  }
}

data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id
  name   = "cloudcasts-staging-public-sg"
}


##############################################################################

resource "aws_iam_role" "iam_role_for_lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

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

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole-attach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "AmazonElasticFileSystemClientFullAccess-attach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = data.aws_iam_policy.AmazonElasticFileSystemClientFullAccessRole.arn
}
