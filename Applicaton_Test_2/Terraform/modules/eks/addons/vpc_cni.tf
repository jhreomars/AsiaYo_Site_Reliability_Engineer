resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.cluster_name
  addon_name                 = "vpc-cni"
  addon_version              = var.vpc_cni_version
  resolve_conflicts          = "OVERWRITE"
  service_account_role_arn   = aws_iam_role.vpc_cni.arn

  configuration_values = jsonencode({
    enablePrefixDelegation = var.vpc_cni_prefix_delegation
    warmIPTarget          = var.vpc_cni_warm_ip_target
    minimumIPTarget      = var.vpc_cni_minimum_ip_target
  })
}

resource "aws_iam_role" "vpc_cni" {
  name = "${var.cluster_name}-vpc-cni"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni.name
}