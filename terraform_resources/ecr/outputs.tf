output "ecr_repo" {
  description = "List of IDs of private subnets"
  value       = aws_ecr_repository.fluence-devops[*].name
}