########### PROGRAM ASSESSMENT BATCH JOB QUEUE ##############
resource "aws_batch_job_queue" "program_assessment" {
  name                 = var.RESOURCE_NAME
  state                = "ENABLED"
  priority             = 1
  compute_environments = var.compute_environments_arn
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

########### PROGRAM ASSESSMENT BATCH JOB DEFINITION ##############
resource "aws_batch_job_definition" "program_assessment" {
  name = var.RESOURCE_NAME
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    image            = "${aws_ecr_repository.program_assessment_repo.repository_url}:latest",
    command          = ["echo", "Starting Program assessment..."],
    executionRoleArn = var.iam_role_arn,
    jobRoleArn       = var.iam_role_arn,

    resourceRequirements = [
      {
        type  = "VCPU",
        value = "${var.aws_batch_JD_vcpu}",
      },
      {
        type  = "MEMORY",
        value = "${var.aws_batch_JD_memory}",
      },
    ],

    runtimePlatform = {
      operatingSystemFamily = "LINUX",
      cpuArchitecture       = "X86_64",
    }
  })

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

output "AWS_BATCH_JOB_NAME" {
  value = aws_batch_job_definition.program_assessment.name
}

output "aws_batch_JD_vcpu" {
  value = var.aws_batch_JD_vcpu
}

output "aws_batch_JD_memory" {
  value = var.aws_batch_JD_memory
}

output "Batch_Job_Definition_ARN" {
  value = aws_batch_job_definition.program_assessment.arn
}
