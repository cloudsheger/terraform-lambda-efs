provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "terraform_function_role" {
  name               = "terraform_function_role"
  assume_role_policy = "${data.aws_iam_policy_document.AWSLambdaTrustPolicy.json}"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = "${aws_iam_role.terraform_function_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "lambda" {
  source = "./modules/lambda"

  name = "${var.stage}-${var.name}-function"

  deployment_package = "${path.module}/example/dist/function.zip"
  handler = var.handler
  runtime = var.runtime
  timeout = var.timeout
  memory_size = var.memory_size

  iam_role_for_lambda = "${aws_iam_role.terraform_function_role.arn}"

  subnet_ids = ["subnet-0e1b7de55bb0d12fb"]
  security_groups = [ "sg-0d31822b4384b66b7" ]

  efs_access_point_arn = module.efs.access_point_arn
  efs_mount_targets = module.efs.mount_targets

  local_mount_path = var.local_mount_path

}

module "efs" {
  source = "./modules/efs"

  name = "${var.stage}-${var.name}-efs"
  //subnet_ids = module.vpc.private_subnetes
  subnet_ids = ["subnet-0e1b7de55bb0d12fb"]
  //security_group_ids = [module.vpc.sg_for_lambda.id]
  security_group_ids = [ "sg-0d31822b4384b66b7" ]
  provisioned_throughput = var.efs_provisioned_throughput
  throughput_mode = var.efs_throughput_mode
}
