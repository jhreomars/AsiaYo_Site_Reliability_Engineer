# 基礎設施相關的核心組件
module "core_components" {
  source = "./core_components"
  
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  
  # API Server 配置
  api_server_config = {
    enabled_log_types = ["api", "audit", "authenticator"]
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  
  # ETCD 配置
  etcd_config = {
    encryption_enabled = true
    backup_enabled    = true
    backup_retention  = 7
  }
}