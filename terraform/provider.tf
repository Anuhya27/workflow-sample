terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

  }

  backend "s3" {
    bucket = "program-assessment"
    region = "us-east-2"
    key = "terraform/terraform.tfstate"
  }
  required_version = "~> 1.0"
}

provider "aws" {
    var.AWS_REGION
  # Other provider configuration options, if needed
}

variable "AWS_REGION" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"  # Set a default region or leave it empty
}