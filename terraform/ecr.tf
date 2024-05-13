########### PROGRAM ASSESSMENT ECR REPOSITORY ##############
resource "aws_ecr_repository" "program_assessment_repo" {
  name                 = var.ecr_image_name
  image_tag_mutability = "IMMUTABLE"
}

output "repository_url" {
  value = aws_ecr_repository.program_assessment_repo.repository_url
}
