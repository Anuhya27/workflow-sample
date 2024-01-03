variable "region" {}
variable "vpc_name" {}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  required_version = ">=0.14.9"

}

provider "aws" {
    version = "5.31.0"
    region = "us-east-1"
}


resource "aws_instance" "my-first-server" {
    ami = "ami-079db87dc4c10ac91"
    instance_type = "t2.micro"
    tags = {
        Name = "Second Instance"
    }
}

# data "aws_ami" "latest_amazon_linux" {
#     most_recent = true
#     owners = ["amazon"]
#     filter {
#         name = "name"
#         values= ["amzn2-ami-hvm-*"]
#     }
#     filter {
#         name = "architecture"
#         values = ["x86_64"]
#     }
#     filter {
#         name = "root-device-type"
#         values = ["ebs"]
#     }
# }

# data "aws_vpc" "selected_vpc" {
# 	filter {
# 	   name = "tag:Name"
# 	   values = [var.vpc_name]
# 	}
# }

# data "aws_subnets" "private" {
# 	filter {
# 	   name = "vpc-id"
# 	   values = [data.aws_vpc.selected_vpc.id]
# 	}
# 	tags = {
# 		Type = "private"
# 	}
# }

# resource "aws_instance" "ec2_instance" {
# 	ami = data.aws_ami.latest_amazon_linux.id
#     instance_type = "t2.micro"
# 	subnet_id = data.aws_subnets.private.ids[0]
# }