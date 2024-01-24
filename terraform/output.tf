output "repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
}

# output "registry_id" {
#   value = aws_ecr_repository.ecr_repository.registry_id
#   description = "The registry ID where the repository was created."
# }

# output "account_id" {
#   value = data.aws_caller_identity.current.account_id
# }

# output "caller_arn" {
#   value = data.aws_caller_identity.current.arn
# }

# output "caller_user" {
#   value = data.aws_caller_identity.current.user_id
# }
# output "role_arn" {
#   value = aws_iam_role.batch_service_role.arn
# }

