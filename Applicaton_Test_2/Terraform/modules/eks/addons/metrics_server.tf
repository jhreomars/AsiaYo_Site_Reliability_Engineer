resource "helm_release" "metrics_server" {
  count      = var.enable_metrics_server ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = var.metrics_server_version

  set {
    name  = "args[0]"
    value = "--kubelet-preferred-address-types=InternalIP"
  }

  set {
    name  = "resources.limits.cpu"
    value = var.metrics_server_resources.limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.metrics_server_resources.limits.memory
  }
}