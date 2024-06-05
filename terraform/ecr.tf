########### PROGRAM ASSESSMENT ECR REPOSITORY ##############
resource "aws_ecr_repository" "program_assessment_repo" {
  name                 = var.RESOURCE_NAME
  image_tag_mutability = "IMMUTABLE"

  tags = {
    "Name"               = var.Name
    "Cost_Center_Name"   = var.Cost_Center_Name
    "Department"         = var.Department
    "epi:team"           = var.Team
    "epi:supported-by"   = var.SupportedBy
    "epi:owner"          = var.Owner
    "epi:environment"    = var.Environment
    "epi:product-stream" = var.ProductStream
  }
}

output "repository_url" {
  value = aws_ecr_repository.program_assessment_repo.repository_url
}

output "ECR_REPO_NAME" {
  value = aws_ecr_repository.program_assessment_repo.name
}
