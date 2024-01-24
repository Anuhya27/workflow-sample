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
