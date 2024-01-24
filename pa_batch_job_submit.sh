#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: $0 <job>"
  exit 1
fi

job=$1

job_definition_name = "program_assessment"
job_queue_name = "program_assessment"

case $job in
  "pa")
    
    aws batch submit-job \
     --job-name job1 \
     --job-definition $job_definition_name\
     --job-queue $job_queue_name \
     --container-overrides "command=["python","batch_app.py","--user_input", \"$test\"]"
    ;;

  "benchmark_individual")

    string_list=("job5" "job6" "job7")

    for string in "${string_list[@]}"; do
        aws batch submit-job \
        --job-name $string \
        --job-definition $job_definition_name\
        --job-queue $job_queue_name \
        --container-overrides "command=["python","batch_app.py","--user_input", \"$string\"]"
    done
    ;;
    
  "merge_benchmark")

    test = "merge_benchmark"

    aws batch submit-job \
     --job-name job1 \
     --job-definition $job_definition_name\
     --job-queue $job_queue_name \
     --container-overrides "command=["python","batch_app.py","--user_input", \"$test\"]"
    ;;
  *)
    echo "Unknown job: $job"
    exit 1
    ;;
esac
