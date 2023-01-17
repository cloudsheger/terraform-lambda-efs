variable "name" {
  description = "lambda function name"
}

variable "filename" {
  description = "lambda deployment package"
}

variable "source_code_hash"{
  description = "lambda function hash code"
}

variable "handler" {
  description = "lambda handler"
}

variable "runtime" {
  description = "lambda runtime"
}

variable "timeout" {
  description = "lambda timeout in seconds"
  default = 3
}
variable "memory_size" {
  description = "lambda memory size in MB"
  default = 128
}

variable "subnet_ids" {
  description = "subnet ids for lambda function"
}

variable "security_groups_ids" {
  description = "security group ids for lambda function"
  type = list(string)
  default = []
}

variable "efs_access_point_arn" {
  description = "efs access point arn"
}

variable "local_mount_path" {
  description = "local mount path in lambda function. must start with '/mnt/'"
  default = "/mnt/efs"
}

variable "efs_mount_targets" {
  description = "efs file system mount targets"
}
variable "role" {
  description = "terrafom role for lambda"
  
}