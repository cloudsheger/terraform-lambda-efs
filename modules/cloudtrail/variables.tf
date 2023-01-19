variable "s3-bucket-cloudtrail" {
    description = "s3 bucket to store cloud trail logs"
    default = "ztpt-lambda-cloudtrail-bucket"
}
variable "cloudtrail-lambda" {
    description = "Cloudtrail to monitor lambda excusions"
    default = "ztpt-cloudtrail"
  
}
variable "s3-bucket-key" {
    description = "s3 bucket key"
    default = "cloudtrail"
}