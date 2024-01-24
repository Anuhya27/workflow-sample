data "aws_caller_identity" "current" {}

variable "ecr_image_name" {
  default = "program-assessment"
}

variable "compute_env_name" {
  default = "program_assessment"
}

variable "iam_role_name" {
  default = "program_assessment"
}

data "aws_ecr_image" "program_assessment" {
  repository_name = "test_ecr"
  most_recent       = true
}

##### IAM POLICIES #####
variable "program_assessment_role_policies" {
  default = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"]
}

##### SUBNETS #####
variable "subnets" {
  default = ["subnet-0069df4a11c71f83b", "subnet-08c54de6284fdd84e", "subnet-01c7dc9aa84b68143"]
}

##### SECURITY GROUPS #####
variable "security_groups" {
  default = ["sg-065d8bff00070debc"]
}
