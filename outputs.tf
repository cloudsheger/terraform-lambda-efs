output "access_point_arn" {
  value = module.efs.access_point_arn
}

output "mount_targets" {
  value = module.efs.mount_targets
}

output "iam_role_for_lambda_name" {
  description = "Name of the lambda execution role."
  value       = module.iam.iam_role_for_lambda_name
}

output "iam_role_for_lambda_arn" {
  description = "Amazon Resource Name (ARN) specifying the lambda execution role."
  value       = module.iam.iam_role_for_lambda_arn
}

output "cloudtrail_name" {
  value = module.cloudtrail.cloudtrail_name
}

output "cloudtrail_bucket" {
  value = module.cloudtrail.cloudtrail_bucket
}