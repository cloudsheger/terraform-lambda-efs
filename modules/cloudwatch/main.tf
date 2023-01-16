locals {
  log_retention_in_days = var.log_retention_in_days
  lambda_name           = var.lambda_name

  tags = {
    #lambda_name = local.lambda_name
    testing     = "true"
  }
}

resource "aws_cloudwatch_log_group" "lambda_monitor" {
  name              = "/aws/lambda/${local.lambda_name}-2023"
  retention_in_days = local.log_retention_in_days
  tags              = local.tags
}
