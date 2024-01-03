variable "region" {}
variable "vpc_name" {}

provider "aws" {
    region = var.region
}

data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values= ["amzn2-ami-hvm-*"]
    }
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
}

data "aws_vpc" "selected_vpc" {
    filter {
        name = "tag:Name"
    }
}