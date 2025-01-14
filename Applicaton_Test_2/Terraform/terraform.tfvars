aws_region    = "ap-northeast-1"
environment   = "prod"
project_name  = "asiayo"
vpc_cidr      = "10.0.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
  "ap-northeast-1d"
]

default_tags = {
  Project     = "asiayo"
  Environment = "prod"
  ManagedBy   = "Terraform"
  Owner       = "DevOps"
}