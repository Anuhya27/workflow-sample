terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-2"
}

# single ecr
module "ecr" {
  source = "./terraform"

  name                  = "nginx"
  project_family        = "demoecr"
  
}

# resource "aws_iam_role" "sagemaker_model" {

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "sagemaker.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF

# }

# resource "aws_iam_policy" "ecr" {

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "VisualEditor0",
#       "Effect": "Allow",
#       "Action": [
#         "ecr:*"
#       ],
#       "Resource": [
#         "*"
#       ]
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "model_attach_ecr" {
#   role       = aws_iam_role.sagemaker_model.name
#   policy_arn = aws_iam_policy.ecr.arn
# }

# resource "aws_ecr_repository" "ecr_repository" {
#   name                 = "test_ecr"
# }


# resource "aws_ecr_repository_policy" "policy" {

#   repository = aws_ecr_repository.ecr_repository.name
#   policy     = <<EOF
# {
#   "Version": "2008-10-17",
#   "Statement": [
#     {
#       "Sid": "new statement",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "${aws_iam_role.sagemaker_model.arn}"
#       },
#       "Action": [
#         "ecr:*"
#       ]
#     }
#   ]
# }
# EOF
# }

# # locals {
# #   project_family = "demoecr"
# #   repositories = {
# #     "workflow" = {
# #       image_tag_mutability  = "IMMUTABLE"
# #       scan_on_push          = true
# #       expiration_after_days = 7
# #       environment           = "dev"
# #       tags = {
# #         Project     = "Demo"
# #         Purpose     = "Reverse Proxy"
# #         Description = "Workflow docker image"
# #       }
# #     }

# #     # "frontend" = {
# #     #   image_tag_mutability  = "IMMUTABLE"
# #     #   scan_on_push          = true
# #     #   expiration_after_days = 3
# #     #   environment           = "dev"
# #     #   tags = {
# #     #     Project     = "ECRDemo"
# #     #     Owner       = "anotherbuginthecode"
# #     #     Purpose     = "Frontend"
# #     #     Description = "Frontend docker image using ReactJS"
# #     #   }
# #     # }

# #     # "backend" = {
# #     #   image_tag_mutability  = "IMMUTABLE"
# #     #   scan_on_push          = true
# #     #   environment           = "dev"
# #     #   expiration_after_days = 0 # no expiration policy set
# #     #   tags = {
# #     #     Project     = "ECRDemo"
# #     #     Owner       = "anotherbuginthecode"
# #     #     Purpose     = "Backend"
# #     #     Description = "Backend docker image using Python Flask"
# #     #   }
# #     # }
# #   }
# # }


# # # multiple ecr
# # module "ecr" {
# #   source   = "./terraform"
# #   for_each = local.repositories

# #   name                  = each.key
# #   project_family        = local.project_family
# #   environment           = each.value.environment
# #   image_tag_mutability  = each.value.image_tag_mutability
# #   scan_on_push          = each.value.scan_on_push
# #   expiration_after_days = each.value.expiration_after_days
# #   additional_tags       = each.value.tags

# # }


# # # terraform {
# # #   required_providers {
# # #     aws = {
# # #       source = "hashicorp/aws"
# # #       Version = "~>3.10"
# # #     }
# # #   }

# # #   required_version = ">=0.14.9"

# # # }

# # # provider "aws" {
# # #   version = "~>3.0"
# # #   region  = "east-us-1"
# # # }


# # # ##############################################
# # # variable "region" {}
# # # variable "vpc_name" {}

# # terraform {
# #   required_providers {
# #     aws = {
# #       source = "hashicorp/aws"
# #       version = "~>3.10"
# #     }
# #   }
# #   required_version = ">=0.14.9"

# # }

# # provider "aws" {
# #     region = "us-east-1"
# # }


# # resource "aws_instance" "my-third-server" {
# #     ami = "ami-079db87dc4c10ac91"
# #     instance_type = "t2.micro"
# #     tags = {
# #         Name = "Third Instance"
# #     }
# # }

# # # # data "aws_ami" "latest_amazon_linux" {
# # # #     most_recent = true
# # # #     owners = ["amazon"]
# # # #     filter {
# # # #         name = "name"
# # # #         values= ["amzn2-ami-hvm-*"]
# # # #     }
# # # #     filter {
# # # #         name = "architecture"
# # # #         values = ["x86_64"]
# # # #     }
# # # #     filter {
# # # #         name = "root-device-type"
# # # #         values = ["ebs"]
# # # #     }
# # # # }

# # # # data "aws_vpc" "selected_vpc" {
# # # # 	filter {
# # # # 	   name = "tag:Name"
# # # # 	   values = [var.vpc_name]
# # # # 	}
# # # # }

# # # # data "aws_subnets" "private" {
# # # # 	filter {
# # # # 	   name = "vpc-id"
# # # # 	   values = [data.aws_vpc.selected_vpc.id]
# # # # 	}
# # # # 	tags = {
# # # # 		Type = "private"
# # # # 	}
# # # # }

# # # # resource "aws_instance" "ec2_instance" {
# # # # 	ami = data.aws_ami.latest_amazon_linux.id
# # # #     instance_type = "t2.micro"
# # # # 	subnet_id = data.aws_subnets.private.ids[0]
# # # # }
