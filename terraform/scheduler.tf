resource "aws_scheduler_schedule" "cron" {
  name       = "test_schedule"
  group_name = "default"
  depends_on = [aws_iam_role.scheduler-batch-role, aws_batch_job_definition.batch_job,
  aws_batch_job_queue.batch_queue]
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = "35 11 * * 4"
  schedule_expression_timezone = "Asia/Calcutta" # Default is UTC
  description                  = "submitJob Batch event"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:batch:submitJob"
    role_arn = var.iam_role_arn

    input = jsonencode({
      "JobName" : "${aws_batch_job_definition.program_assessment.name}",
      "JobDefinition" : "${aws_batch_job_definition.program_assessment.name}",
      "JobQueue" : "${aws_batch_job_queue.program_assessment.arn}"
    })
  }
}
