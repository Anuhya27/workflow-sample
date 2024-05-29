########### PROGRAM ASSESSMENT BATCH COMPUTE ENVIRONMENT ##############
resource "aws_vpc" "sample" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "sample" {
  vpc_id     = aws_vpc.sample.id
  cidr_block = "10.1.1.0/24"
}

resource "aws_security_group" "sample" {
  name = "aws_batch_compute_environment_security_group"
  vpc_id      = aws_vpc.sample.id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_batch_compute_environment" "program_assessment" {
  compute_environment_name = var.JOB_DEFINITION
  type                     = "MANAGED"
  state                    = "ENABLED"

  compute_resources {
    type               = "FARGATE"
    max_vcpus          = 8
    # security_group_ids = var.security_groups
    subnets = [
      aws_subnet.sample.id,
    ]

    security_group_ids = [
      aws_security_group.sample.id,
    ]
    
  }
    tags = {
    "Name" = var.Name
    "Cost_Center_Name" = var.Cost_Center_Name
    "Department" = var.Department
    "epi:team" = var.Team
    "epi:supported-by" = var.SupportedBy
    "epi:owner" = var.Owner
    "epi:environment" = var.Environment
    "epi:product-stream" = var.ProductStream
  }
}

########### PROGRAM ASSESSMENT BATCH JOB QUEUE ##############
resource "aws_batch_job_queue" "program_assessment" {
  name                 = var.JOB_DEFINITION
  state                = "ENABLED"
  priority             = 1
  compute_environments = [aws_batch_compute_environment.program_assessment.arn]
    tags = {
    "Name" = var.Name
    "Cost_Center_Name" = var.Cost_Center_Name
    "Department" = var.Department
    "epi:team" = var.Team
    "epi:supported-by" = var.SupportedBy
    "epi:owner" = var.Owner
    "epi:environment" = var.Environment
    "epi:product-stream" = var.ProductStream
  }
}

########### PROGRAM ASSESSMENT BATCH JOB DEFINITION ##############
resource "aws_batch_job_definition" "program_assessment" {
  name = var.JOB_DEFINITION
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    image            = "${aws_ecr_repository.program_assessment_repo.repository_url}:latest",
    command          = ["echo", "Starting Program assessment..."],
    executionRoleArn = aws_iam_role.program_assessment_role.arn,
    jobRoleArn       = aws_iam_role.program_assessment_role.arn,

    resourceRequirements = [
      {
        type  = "VCPU"
        value = var.aws_batch_JD_vcpu
      },
      {
        type  = "MEMORY"
        value = var.aws_batch_JD_memory
      }
    ],
    
  })
    tags = {
    "Name" = var.Name
    "Cost_Center_Name" = var.Cost_Center_Name
    "Department" = var.Department
    "epi:team" = var.Team
    "epi:supported-by" = var.SupportedBy
    "epi:owner" = var.Owner
    "epi:environment" = var.Environment
    "epi:product-stream" = var.ProductStream
  }
}
