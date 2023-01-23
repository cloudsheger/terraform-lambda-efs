# upload zip to s3 and then update lamda function from s3
resource "aws_s3_object" "lambda_package" {
  bucket = "s3_bucket_lambda_package"
  key    = "lambda_package.zip"
  #source = archive_file("path/to/lambda_package", "zip")
  source = var.upload_file
  acl    = "private"

  force_destroy = true

}
