variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "node_groups" {
  description = "EKS node groups configuration"
  type = map(object({
    name           = string
    instance_types = list(string)
    min_size      = number
    max_size      = number
    desired_size  = number
  }))
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}