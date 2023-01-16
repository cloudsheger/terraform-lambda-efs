terraform {
  required_version = ">= 1.3.2"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
  }
}