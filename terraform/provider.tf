terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

  }

  backend "s3" {
    bucket = "program-assessment"
    region = var.aws_region
    key = "terraform/terraform.tfstate"
  }
  required_version = "~> 1.0"
}

provider "aws" {
    region = var.aws_region
  # Other provider configuration options, if needed
}

output "AWS_REGION" {
    value = var.aws_region
}
