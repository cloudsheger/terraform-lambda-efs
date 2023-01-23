resource "aws_cloudtrail" "main" {
  name                      = var.cloudtrail-lambda
  s3_bucket_name            = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix             = var.s3-bucket-key
  include_global_service_events = false
  enable_logging                = true
  is_multi_region_trail         = false

depends_on = [aws_s3_bucket_policy.cloudtrail_policy]

}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = var.s3-bucket-cloudtrail
  force_destroy = true
 # lifecycle {
  #  pre_destroy = "./remove_objects_from_s3.sh"
  #}
}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  policy = <<EOF

{
        "Version": "2012-10-17",
        "Statement": [
                {
                        "Sid": "AWSCloudTrailAclCheck",
                        "Effect": "Allow",
                        "Principal": {
                                "Service": "cloudtrail.amazonaws.com"
                        },
                        "Action": "s3:GetBucketAcl",
                        "Resource": "arn:aws:s3:::${var.s3-bucket-cloudtrail}"
                },
                {
                        "Sid": "AWSCloudTrailWrite",
                        "Effect": "Allow",
                        "Principal": {
                                "Service": "cloudtrail.amazonaws.com"
                        },
                        "Action": "s3:PutObject",
                        "Resource": [
                        "arn:aws:s3:::${var.s3-bucket-cloudtrail}/${var.s3-bucket-key}/AWSLogs/083407797149/*"
                        ],
                        "Condition": {
                                "StringEquals": {
                                        "s3:x-amz-acl": "bucket-owner-full-control"
                                }
                        }
                }
        ]
}
EOF
}