variable "name" {
  description = "the name fo the vpc"
  default = "cloudcasts-staging-vpc"
}

variable "subnet_ids" {
  description = "subnet id"
  type = list(string)
  default = ["subnet-0e1b7de55bb0d12fb"]
}

variable "security_group" {
  description   = "security group id"
  type = list(string)
  default  = ["sg-0d31822b4384b66b7"]
}

