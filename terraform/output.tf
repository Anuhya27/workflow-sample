# output "repository_url" {
#   value = aws_ecr_repository.ecr_repository.repository_url
#   description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
# }

# output "registry_id" {
#   value = aws_ecr_repository.ecr_repository.registry_id
#   description = "The registry ID where the repository was created."
# }

output "ECS_TASK_EXECUTION_ROLE" {
  value = var.iam_role_name
}


output "AWS_BATCH_JOB_NAME" {
  value = var.compute_env_name
}



output "ECR_REPO_NAME" {
  value = var.ecr_image_name
}

# output "aws_batch_JD_vcpu" {
#   value = var.aws_batch_JD_vcpu
# }

# output "aws_batch_JD_memory" {
#   value = var.aws_batch_JD_memory
# }


# output "EventBridge_Rule_Name" {
#   value = var.eventbridge_rule_name
# }



output "Batch_Job_Queue_ARN" {
  value = aws_batch_job_queue.batch_queue.arn
}


output "Scheduler_Batch_Role_ARN" {
  value = aws_iam_role.scheduler-batch-role.arn
}


output "Scheduler_Batch_target_id" {
  value = aws_scheduler_schedule.cron.id
}