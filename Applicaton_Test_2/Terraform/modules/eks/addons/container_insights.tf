resource "aws_eks_addon" "container_insights" {
  count            = var.enable_container_insights ? 1 : 0
  cluster_name     = var.cluster_name
  addon_name      = "amazon-cloudwatch-observability"
  addon_version   = var.container_insights_version
  resolve_conflicts = "OVERWRITE"
}

resource "aws_cloudwatch_log_group" "container_insights" {
  count             = var.enable_container_insights ? 1 : 0
  name              = "/aws/containerinsights/${var.cluster_name}/performance"
  retention_in_days = var.container_insights_retention_days
}