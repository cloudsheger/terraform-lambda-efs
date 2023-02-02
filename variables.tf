variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "stage" {
  description = "application stage/environment (dev, test, prod...)"
}

variable "name" {
  description = "application name"
}

variable "deployment_package" {
  description = "lambda deployment package"
}

variable "handler" {
  description = "lambda function handler"
}

variable "runtime" {
  description = "lambda function runtime"
}

variable "log_retention_in_days" {
  description = "log retention time"
  default = 7
}
variable "timeout" {
  description = "lambda function timeout"
  default = 100
}

variable "memory_size" {
  description = "lambda function memory size"
  default = 1024
}

variable "local_mount_path" {
  description = "local mount path inside lambda function. must start with '/mnt/'. default is '/mnt/shared'"
  default = "/mnt/cloudsheger-project"
}

variable "efs_throughput_mode" {
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned. When using provisioned, also set provisioned_throughput_in_mibps"
  default = null
}

variable "efs_provisioned_throughput" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to `provisioned`"
  default = null
}

variable "subnet_ids" {
  description = "target subnet ids to mount efs file system"
  type = list(string)
  default = ["subnet-0be9bf69885fb438d"]
}

variable "security_group_ids" {
  description = "security group ids for the mount targets"
  type = list(string)
  default = ["sg-0d31822b4384b66b7"]
}

variable "lambda_root" {
  type        = string
  description = "The relative path to the source of the lambda"
  default     = "lambda"
}