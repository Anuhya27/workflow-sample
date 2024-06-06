data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "aws_region" {
  description = "AWS region to deploy resources"
}

output "current_aws" {
  value = data.aws_caller_identity.current
}

output "current_aws_region" {
  value = data.aws_region.current
}

variable "RESOURCE_NAME" {
  description = "Program assessment resource name"
}

variable "iam_role_name" {
  default = "program_assessment_role"
}

variable "iam_role_policy" {
  default = "program_assessment_policy"
}

variable "aws_batch_JD_vcpu" {
  default     = "8"
  type        = string
  description = "VCPU for AWS Batch Job Description"
}

variable "aws_batch_JD_memory" {
  default     = "16384"
  type        = string
  description = "Memory for AWS Batch Job Description"
}

##### IAM POLICIES #####
variable "program_assessment_role_policies" {
  default = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"]
}

variable "iam_role_arn" {
  default = "arn:aws:iam::050223225208:role/program_assessment_role"
  
}

##### SUBNETS #####
variable "subnets" {
  default = ["subnet-07df0578c89cfbfb8"]
}

##### SECURITY GROUPS #####
variable "security_groups" {
  default = ["sg-03b98a8f87a5fa633"]
}

##### TAGS #####
variable "Name" {
  description = "Resource Name"
}

variable "Cost_Center_Name" {
  default = "EpiAnalyst_Ops_Tech_Licenses"
}

variable "Department" {
  default = "PET"
}

variable "Team" {
  default = "PET"
}

variable "SupportedBy" {
  default = "PET"
}

variable "Owner" {
  default = "gowtham.veerappan@episource.com"
}

variable "Environment" {
  description = "Environment name"
}

variable "ProductStream" {
  default = "analyst"
}

output "Tag_environment" {
  value = var.Environment
}

output "Tag_name" {
  value = var.Name
}

output "iam_role_arn" {
  value = var.iam_role_arn
}

variable "compute_environments_arn" {
  description = "Common compute environemt arn"
}
