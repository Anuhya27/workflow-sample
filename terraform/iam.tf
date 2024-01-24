# IAM Role for Program assesssment 
resource "aws_iam_role" "program_assessment" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
  
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = "${var.iam_role_name}"
  count      = "${length(var.program_assessment_role_policies)}"
  policy_arn = "${var.program_assessment_role_policies[count.index]}"
}

# IAM Role for Program assesssment policy attachment
resource "aws_iam_policy" "program_assessment_policy" {
  name = "program_assessment_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect"   = "Allow",
        "Action"   = "cloudwatch:PutMetricData",
        "Resource" = "*"
      },
      {
        "Action" = [
          "s3:PutObject",
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          # "arn:aws:s3:::petm/apps/program_assessment/"
          "*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "program_assessment_policies" {
  role       = aws_iam_role.program_assessment.name
  policy_arn = aws_iam_policy.program_assessment_policy.arn
}

output "program_assessment_role_arn" {
  value = aws_iam_role.program_assessment.arn
}
