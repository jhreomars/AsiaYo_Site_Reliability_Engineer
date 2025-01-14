resource "aws_eks_addon" "coredns" {
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = var.coredns_version
  resolve_conflicts = "OVERWRITE"
  
  configuration_values = jsonencode({
    replicaCount = var.coredns_replica_count
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
  })
}