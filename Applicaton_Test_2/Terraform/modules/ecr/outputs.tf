output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_arn" {
  description = "The ARN of the repository"
  value       = aws_ecr_repository.main.arn
}

output "repository_name" {
  description = "The name of the repository"
  value       = aws_ecr_repository.main.name
}

output "ecr_read_policy_arn" {
  description = "ARN of the ECR read policy"
  value       = aws_iam_policy.ecr_read_policy.arn
}