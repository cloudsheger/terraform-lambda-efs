output "s3_bucket_id" {
  value = aws_s3_object.lambda_package.id
}

output "s3_bucket_key" {
  value = aws_s3_object.lambda_package.key
}

output "s3_bucket_version" {
  value = aws_s3_object.lambda_package.version_id
}