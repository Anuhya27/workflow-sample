resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.ecr_image_name
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "policy" {

  repository = aws_ecr_repository.ecr_repository.name
  policy     = jsonencode({
  "Version" =   "2008-10-17",
  "Statement" = [
    {
      Sid = "new statement",
      "Effect" = "Allow",
      "Principal" = {
        "AWS" = aws_iam_role.program_assessment.arn,
      },
      "Action" = [
        "ecr:*"
      ],
    }
  ],
})
}