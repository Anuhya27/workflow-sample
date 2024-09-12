resource "aws_scheduler_schedule" "cron" {
  name       = "test_schedule"
  group_name = "default"
  depends_on = [ aws_batch_job_definition.program_assessment,
  aws_batch_job_queue.program_assessment]
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = "cron(15 16 ? * 5 *)"
  schedule_expression_timezone = "Asia/Calcutta" # Default is UTC
  description                  = "submitJob Batch event"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:batch:submitJob"
    role_arn = "arn:aws:iam::050223225208:role/scheduler_role"

    input = jsonencode({
      "JobName" : "${aws_batch_job_definition.program_assessment.name}",
      "JobDefinition" : "${aws_batch_job_definition.program_assessment.arn}",
      "JobQueue" : "${aws_batch_job_queue.program_assessment.arn}"
    })
  }
}
