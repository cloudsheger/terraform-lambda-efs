module "lambda" {
  source = "./modules/lambda"

  name             = "${var.stage}-${var.name}-function"
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  cloudtrail_arn   = module.cloudtrail.cloudtrail_arn
  role             = module.iam.iam_role_for_lambda_arn
  subnet_ids = var.subnet_ids
  security_groups_ids = var.security_group_ids
  efs_access_point_arn = module.efs.access_point_arn
  efs_mount_targets    = module.efs.mount_targets
  local_mount_path     = var.local_mount_path
  depends_on           = [module.iam.AWSLambdaVPCAccessExecutionRole-attach,
                          module.iam.AmazonElasticFileSystemClientFullAccess-attach,
                          module.cloudwatch.lambda_monitor,
                          module.cloudtrail.cloudtrail_policy]  
}

module "efs" {
  source = "./modules/efs"

  name                   = "${var.stage}-${var.name}-efs"
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

module "cloudtrail" {
  source = "./modules/cloudtrail"
}