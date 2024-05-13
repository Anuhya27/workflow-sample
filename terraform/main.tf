# # resource "aws_iam_role" "iam_lambda_test" {
# #   name                 = "lambda_test_iam"
# #   assume_role_policy   = jsonencode({
# #     Statement = [{
# #       Action = "sts:AssumeRole"
# #       Effect = "Allow"
# #       Principal = {
# #         Service = "lambda.amazonaws.com"
# #       }
# #     }]
# #     Version = "2023-09-06"
# #   })
# # }

# # resource "aws_iam_role" "role" {
# #   name = "test-role"

# #   assume_role_policy = <<EOF
# # {
# #     "Version": "2012-10-17",
# #     "Statement": [
# #     {
# #         "Action": "sts:AssumeRole",
# #         "Principal": {
# #         "Service": "ec2.amazonaws.com"
# #         },
# #         "Effect": "Allow",
# #         "Sid": ""
# #     }
# #     ]
# # }
# # EOF
# # }

# # resource "aws_iam_policy" "policy" {
# #   name        = "test-policy"
# #   description = "A test policy"

# #   policy = <<EOF
# # {
# #   "Version": "2012-10-17",
# #   "Statement": [
# #     {
# #       "Action": [
# #         "ecr:*",
# #         "cloudtrail:LookupEvents"
# #       ],
# #       "Effect": "Allow",
# #       "Resource": "*"
# #     }
# #   ]
# # }
# # EOF
# # }

# # resource "aws_iam_role_policy_attachment" "test-attach" {
# #   role       = "${aws_iam_role.role.name}"
# #   policy_arn = "${aws_iam_policy.policy.arn}"
# # }

# # resource "aws_iam_role" "ecs_instance_role" {

# #   assume_role_policy = <<EOF
# # {
# #   "Version": "2012-10-17",
# #   "Statement": [
# #     {
# #       "Action": "sts:AssumeRole",
# #       "Principal": {
# #         "Service": "sagemaker.amazonaws.com"
# #       },
# #       "Effect": "Allow",
# #       "Sid": ""
# #     }
# #   ]
# # }
# # EOF

# # }

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


# data "aws_iam_policy_document" "ec2_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "ecs_instance_role" {
#   name               = "ecs_instance_role"
#   assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "model_attach_ecr" {
#   role       = aws_iam_role.ecs_instance_role.name
#   policy_arn = aws_iam_policy.ecr.arn
# }

# resource "aws_ecr_repository" "ecr_repository" {
#   name                 = "test_ecr"
#   image_tag_mutability = "IMMUTABLE"
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
#         "AWS": "${aws_iam_role.ecs_instance_role.arn}"
#       },
#       "Action": [
#         "ecr:*"
#       ]
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
#   role       = aws_iam_role.ecs_instance_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }

# resource "aws_iam_instance_profile" "ecs_instance_role" {
#   name = "ecs_instance_role"
#   role = aws_iam_role.ecs_instance_role.name
# }

# data "aws_iam_policy_document" "batch_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["batch.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "aws_batch_service_role" {
#   name               = "aws_batch_service_role"
#   assume_role_policy = data.aws_iam_policy_document.batch_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
#   role       = aws_iam_role.aws_batch_service_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
# }

# resource "aws_vpc" "sample" {
#   cidr_block = "10.1.0.0/16"
# }

# resource "aws_subnet" "sample" {
#   vpc_id     = aws_vpc.sample.id
#   cidr_block = "10.1.1.0/24"
# }

# resource "aws_security_group" "sample" {
#   name = "aws_batch_compute_environment_security_group"
#   vpc_id      = aws_vpc.sample.id
  
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_placement_group" "sample" {
#   name     = "sample"
#   strategy = "cluster"
# }

# resource "aws_batch_compute_environment" "sample" {
#   compute_environment_name_prefix = "sample"
#     lifecycle {
#         create_before_destroy = true
#       }

#   compute_resources {
#     instance_role = aws_iam_instance_profile.ecs_instance_role.arn
#     allocation_strategy = "BEST_FIT_PROGRESSIVE"
    
#     instance_type = [
#       "optimal",
#     ]

#     max_vcpus = 5
#     min_vcpus = 1

#     # placement_group = aws_placement_group.sample.name

#     security_group_ids = [
#       aws_security_group.sample.id,
#     ]

#     subnets = [
#       aws_subnet.sample.id,
#     ]


#     type = "EC2"
#   }

#   service_role = aws_iam_role.aws_batch_service_role.arn
#   type         = "MANAGED"
#   depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
# }

# resource "aws_batch_job_queue" "test_queue" {
#   name     = "tf-test-batch-job-queue"
#   state    = "ENABLED"
#   priority = 1
#   compute_environments = [
#     aws_batch_compute_environment.sample.arn,
#   ]
# }

# resource "aws_batch_job_definition" "batch_job_definition" {
#   name           = "sample_job"
#   type           = "container"
#   container_properties = jsonencode({
#     command = ["sample_job"]
#     image = aws_ecr_repository.ecr_repository.name
#     resourceRequirements = [
#       {
#         type = "VCPU"
#         value = "2"
#       },
#       {
#         type = "MEMORY"
#         value = "10000"
#       }
#     ]
#   })
# }
