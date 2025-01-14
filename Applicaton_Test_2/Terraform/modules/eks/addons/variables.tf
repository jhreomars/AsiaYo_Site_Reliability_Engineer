variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "coredns_version" {
  description = "CoreDNS addon version"
  type        = string
  default     = "v1.9.3-eksbuild.3"
}

variable "vpc_cni_version" {
  description = "VPC CNI addon version"
  type        = string
  default     = "v1.12.0-eksbuild.1"
}

# 其他核心組件的變量