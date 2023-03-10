resource "aws_lambda_function" "lambda" {
  function_name    = var.name
  filename         = var.filename
  source_code_hash = var.source_code_hash

  role             = var.role
  #cloudtrail_arn = var.cloudtrail_arn
  handler          = var.handler
  runtime          = var.runtime

  timeout          = var.timeout
  memory_size      = var.memory_size
  environment {
    variables = {
      LOCAL_MOUNT_PATH = var.local_mount_path
    }
  }
  
  vpc_config {

    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_groups_ids

  }
  file_system_config {
    arn              = var.efs_access_point_arn
    local_mount_path = var.local_mount_path
  }

 
  # Explicitly declare dependency on EFS mount target.
  # When creating or updating Lambda functions, mount target must be in 'available' lifecycle state.
  depends_on = [var.efs_mount_targets]

}
