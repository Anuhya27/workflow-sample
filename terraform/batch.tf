resource "aws_batch_compute_environment" "program_assessment" {
  compute_environment_name = var.compute_env_name
  type                    = "MANAGED"
  state                   = "ENABLED"

  compute_resources {
    type              = "FARGATE"
    max_vcpus         = 5
    security_group_ids = var.security_groups
    subnets           = var.subnets
  }
}

# Create a Batch Job Queue
resource "aws_batch_job_queue" "program_assessment" {
  name                 = var.compute_env_name
  state                = "ENABLED"
  priority             = 1
  compute_environments = [aws_batch_compute_environment.program_assessment.arn]
}

resource "aws_batch_job_definition" "program_assessment" {
  name                = var.compute_env_name
  type                = "container"
    
  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    image = "${aws_ecr_repository.ecr_repository.repository_url}:latest",
    command = ["python", "batch_app.py", "--user_input", "hello_from_docker"],
    executionRoleArn       = aws_iam_role.program_assessment.arn,
    resourceRequirements = [
      {
        type  = "VCPU",
        value = "1",
      },
      {
        type  = "MEMORY",
        value = "2048",
      },
    ],
    runtimePlatform      = {
      operatingSystemFamily = "LINUX",
      cpuArchitecture       = "ARM64",
    },
  })
}
