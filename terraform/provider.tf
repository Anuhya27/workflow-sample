terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }

  backend "s3" {
    key = "apps/program_assessment/terraform/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

output "AWS_REGION" {
  value = var.aws_region
}
