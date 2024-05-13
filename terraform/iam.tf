########### PROGRAM ASSESSMENT IAM ROLE ##############C
resource "aws_iam_role" "program_assessment_role" {
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

########### PROGRAM ASSESSMENT IAM POLICY ##############
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = var.iam_role_name
  count      = length(var.program_assessment_role_policies)
  policy_arn = var.program_assessment_role_policies[count.index]
}

########### PROGRAM ASSESSMENT IAM POLICY FOR S3##############
resource "aws_iam_policy" "program_assessment_policy" {
  name = var.iam_role_policy

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ],
        "Resource" : "*"
      },
      {
        "Action" : [
          "s3:ListBucket"
        ],
        "Effect" : "Allow",
        "Resource" : [
          # "arn:aws:s3:::petm"
          "*"
        ]
      },
      {
        "Action" = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          # "arn:aws:s3:::petm/apps/program_assessment*",
          # "arn:aws:s3:::petm/apps/program_assessment*/*"
          "*"
        ]
      },
      {
        "Action" = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Effect = "Allow"
        Resource = [
          "arn:aws:ssm:*:075354070244:parameter/epianalyst/prod/config/PROG*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "program_assessment_policies" {
  role       = aws_iam_role.program_assessment_role.name
  policy_arn = aws_iam_policy.program_assessment_policy.arn
}

output "program_assessment_role_arn" {
  value = aws_iam_role.program_assessment_role.arn
}

output "program_assessment_policy_arn" {
  value = aws_iam_policy.program_assessment_policy.arn
}
