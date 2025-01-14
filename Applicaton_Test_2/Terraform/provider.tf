provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = var.default_tags
  }
}

terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket         = "terraform-state-asiayo"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}