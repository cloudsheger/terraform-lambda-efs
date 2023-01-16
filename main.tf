provider "aws" {
  region = var.aws_region
}

module "lambda" {
  source = "./modules/lambda"

  name             = "${var.stage}-${var.name}-function"
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  handler          = "handler.lambda_handler"
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  #iam_role_for_lambda = module.iam.iam_role_for_lambda.arn
  iam_role_for_lambda  = aws_iam_role.iam_role_for_lambda.arn
  #subnet_ids           = [data.aws_subnet.this.id]
  subnet_ids = var.subnet_ids
  #security_groups_ids  = [data.aws_security_group.this.id]
  security_groups_ids = var.security_group_ids
  efs_access_point_arn = module.efs.access_point_arn
  efs_mount_targets    = module.efs.mount_targets
  local_mount_path     = var.local_mount_path
  
  depends_on           = [aws_iam_role_policy_attachment.AWSLambdaVPCAccessExecutionRole-attach,
                         aws_iam_role_policy_attachment.AmazonElasticFileSystemClientFullAccess-attach,
                         module.cloudwatch.lambda_monitor]  
}

module "efs" {
  source = "./modules/efs"

  name                   = "${var.stage}-${var.name}-efs"
  #subnet_ids             = [data.aws_subnet.this.id]
  #security_group_ids     = [data.aws_security_group.this.id]
  subnet_ids = var.subnet_ids
  security_group_ids = var.security_group_ids
  provisioned_throughput = var.efs_provisioned_throughput
  throughput_mode        = var.efs_throughput_mode
}

module "iam" {
  source = "./modules/iam"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  log_retention_in_days = var.log_retention_in_days
  lambda_name           = "${var.stage}-${var.name}-function"
}

##############################################################################
### IAM ROLE FOR LAMBDA FUNCTION
##############################################################################

resource "aws_iam_role" "iam_role_for_lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole-attach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "AmazonElasticFileSystemClientFullAccess-attach" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = data.aws_iam_policy.AmazonElasticFileSystemClientFullAccessRole.arn
}

###############################################################
# archive data
###############################################################

resource "null_resource" "install_dependencies" {

  provisioner "local-exec" {
    command = "${path.module}/lambda/build.sh"
  }
  triggers = {
    handler      = filemd5("${path.module}/${var.lambda_root}/handler.py")
    requirements = filemd5("${path.module}/${var.lambda_root}/requirements.txt")
    build        = filemd5("${path.module}/${var.lambda_root}/build.sh")
  }
}

# Now, in order to ensure that cached versions of the Lambda aren't invoked by AWS, 
# let's give our zip file a unique name for each version. 
# We can do with by hashing our files together.
resource "random_uuid" "lambda_src_hash" {
  keepers = {
    for filename in setunion(
      fileset("${path.module}/${var.lambda_root}", "handler.py"),
      fileset("${path.module}/${var.lambda_root}", "requirements.txt"),
      fileset("${path.module}/${var.lambda_root}", "build.sh")
    ):
        filename => filemd5("${path.module}/${var.lambda_root}/${filename}")
  }
}

