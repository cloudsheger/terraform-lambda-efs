output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}

output "cloudtrail_name" {
  value = aws_cloudtrail.main.name
}

output "cloudtrail_bucket" {
  value = aws_s3_bucket.cloudtrail_bucket
}
#s3-bucket-cloudtrail.name