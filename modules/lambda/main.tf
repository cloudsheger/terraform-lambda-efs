provider "archive" {}

module lambda_dep {
  source           = "github.com/cloudsheger/terraform-lambda-packaging"
  script_path      = "${path.module}/src/function.py"
  #pip_dependencies = ["pyfiglet==0.8.post1"]
}

resource "aws_lambda_function" "lambda" {
  function_name = var.name

  filename         = var.deployment_package
  #source_code_hash = filebase64sha256(var.deployment_package)
  source_code_hash = module.data.archive_file.lambda_source.output_base64sha256

  role    = var.iam_role_for_lambda
  handler = var.handler
  runtime = var.runtime

  timeout = var.timeout
  memory_size = var.memory_size

  environment {
    variables = {
      LOCAL_MOUNT_PATH = var.local_mount_path
    }
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_groups
  }

  file_system_config {
    arn              = var.efs_access_point_arn
    local_mount_path = var.local_mount_path
  }

  # Explicitly declare dependency on EFS mount target.
  # When creating or updating Lambda functions, mount target must be in 'available' lifecycle state.
  depends_on = [var.efs_mount_targets]

}
