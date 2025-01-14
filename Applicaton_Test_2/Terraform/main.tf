locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "networking" {
  source = "./modules/networking"
  
  name_prefix        = local.name_prefix
  vpc_cidr          = var.vpc_cidr
  availability_zones = var.availability_zones
  
  environment = var.environment
  
  tags = merge(
    var.default_tags,
    {
      Module = "networking"
    }
  )
}

module "eks" {
  source = "./modules/eks"
  depends_on = [module.networking]
  
  name_prefix     = local.name_prefix
  cluster_version = "1.27"
  
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
  
  environment = var.environment
  
  # API Server 配置
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # 啟用 Control Plane Logging
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  
  # 核心組件配置
  enable_core_addons = true
  core_addons_config = {
    # CoreDNS 配置
    coredns = {
      version = "v1.9.3-eksbuild.3"
      replica_count = 2
      resources = {
        limits = {
          cpu    = "100m"
          memory = "170Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "70Mi"
        }
      }
    }

    # VPC CNI 配置
    vpc_cni = {
      version = "v1.12.0-eksbuild.1"
      enable_prefix_delegation = true
      warm_prefix_target = 1
    }

    # Kube Proxy 配置
    kube_proxy = {
      version = "v1.27.1-eksbuild.1"
    }

    # Metrics Server
    metrics_server = {
      enabled = true
      version = "v0.6.3"
    }

    # Cluster Autoscaler
    cluster_autoscaler = {
      enabled = true
      version = "v1.27.2"
      scale_down_delay_after_add = "10m"
      scale_down_unneeded_time = "10m"
    }

    # Container Insights
    container_insights = {
      enabled = true
    }
  }
  
  # 節點組配置
  node_groups = {
    general = {
      name           = "general"
      instance_types = ["t3.large"]
      min_size      = 3
      max_size      = 5
      desired_size  = 3
      
      # 節點標籤和污點
      labels = {
        "role" = "general"
      }
      taints = []
      
      # 容量類型
      capacity_type = "ON_DEMAND"
      
      # 磁碟配置
      disk_size = 50
      
      # 自動擴展配置
      enable_autoscaling = true
    }
  }

  # ETCD 加密配置
  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }
  
  # IRSA 配置
  enable_irsa = true
  
  tags = merge(
    var.default_tags,
    {
      Module = "eks"
    }
  )
}

# KMS key for ETCD encryption
resource "aws_kms_key" "eks" {
  description             = "KMS key for EKS cluster ETCD encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

module "ecr" {
  source = "./modules/ecr"
  
  name_prefix = local.name_prefix
  environment = var.environment
  
  tags = merge(
    var.default_tags,
    {
      Module = "ecr"
    }
  )
}