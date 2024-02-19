terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

  }

  backend "s3" {
    bucket = "program-assessment"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-2"
}

# output "AWS_REGION" {
#   value = var.aws_region
# }
