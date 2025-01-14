output "coredns_version" {
  description = "Installed version of CoreDNS"
  value       = aws_eks_addon.coredns.addon_version
}

# ... 其他輸出定義 ...