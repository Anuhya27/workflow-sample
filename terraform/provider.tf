terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

  }

  backend "s3" {
    key = "apps/program_assessment/terraform/terraform.tfstate"
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

output "AWS_REGION" {
  value = var.aws_region
}
