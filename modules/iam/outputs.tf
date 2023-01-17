output "iam_role_for_lambda_name" {
  description = "Name of the lambda execution role."
  value       = aws_iam_role.iam_role_for_lambda.name
}

output "iam_role_for_lambda_arn" {
  description = "Amazon Resource Name (ARN) specifying the lambda execution role."
  value       = aws_iam_role.iam_role_for_lambda.arn
}