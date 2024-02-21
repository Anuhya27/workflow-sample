data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# variable "aws_region" {
#   description = "AWS region to deploy resources"
# }

output "current_aws" {
  value = data.aws_caller_identity.current
}

output "current_aws_region" {
  value = data.aws_region.current
}

variable "ecr_image_name" {
  default = "program-assessment"
}

variable "compute_env_name" {
  default = "program-assessment"
}

variable "iam_role_name" {
  default = "program_assessment_role"
}

variable "iam_role_policy" {
  default = "program_assessment_policy"
}

##### IAM POLICIES #####
variable "program_assessment_role_policies" {
  default = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"]
}

variable aws_batch_JD_vcpu {
  default = "0.25"
  type        = string
  description = "VCPU for AWS Batch Job Description"
}



variable aws_batch_JD_memory {
  default = "512"
  type        = string
  description = "Memory for AWS Batch Job Description"
}
##### SUBNETS #####
# variable "subnets" {
#   default = ["subnet-6744512f"]
# }

# ##### SECURITY GROUPS #####
# variable "security_groups" {
#   default = ["sg-03e8b400d11651deb"]
# }
