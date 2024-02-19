echo "test"


#!/bin/bash

# Capture output from TF
cd terraform_code
echo $(terraform output ECS_TASK_EXECUTION_ROLE)
echo "EXECUTION_ROLE_ARN=$(terraform output ECS_TASK_EXECUTION_ROLE)" >> $GITHUB_ENV
# ... (other Terraform output variables)

# Configure AWS Credentials
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region $AWS_DEFAULT_REGION

# Capture ECR Repo and Image details
aws_batch_job_name=$(terraform output AWS_BATCH_JOB_NAME | tr -d '"')
ecr_repo_name=$(terraform output ECR_REPO_NAME | tr -d '"')
echo "JOB_NAME=${aws_batch_job_name}" >> $GITHUB_ENV
echo "ECR_REPO_NAME=${ecr_repo_name}" >> $GITHUB_ENV
aws_batch_JD_vcpu_processed=$(terraform output aws_batch_JD_vcpu | tr -d '"')
echo "AWS_BATCH_JD_VCPU=${aws_batch_JD_vcpu_processed}" >> $GITHUB_ENV
aws_batch_JD_memory_processed=$(terraform output aws_batch_JD_memory | tr -d '"')
echo "AWS_BATCH_JD_MEMORY=${aws_batch_JD_memory_processed}" >> $GITHUB_ENV

# Get current JobDefinition revision
REVISION=$(aws batch describe-job-definitions \
  --job-definition-name $JOB_NAME  \
  --status ACTIVE \
  --query "jobDefinitions[0].revision")

echo "revision=$REVISION" >> $GITHUB_ENV

# Register new JobDefinition
NEW_REVISION=$(aws batch register-job-definition \
  --job-definition-name $JOB_NAME \
  --type container \
  --parameters '{"p": "None"}' \
  --retry-strategy '{"attempts": 1,"evaluateOnExit": []}' \
  --container-properties "{\"image\" :\"$ECR_REPO_NAME:$GITHUB_SHA\", 
                    \"resourceRequirements\": [{\"value\": \"$AWS_BATCH_JD_VCPU\",\"type\": \"VCPU\"},{\"value\": \"$AWS_BATCH_JD_MEMORY\",\"type\": \"MEMORY\"}], 
                    \"volumes\":[], 
                    \"environment\": [{\"name\": \"env_var\",\"value\": \"Prod\"}], 
                    \"mountPoints\": [], 
                    \"ulimits\": [], 
                    \"user\": \"root\", 
                    \"jobRoleArn\" : \"$EXECUTION_ROLE_ARN\", 
                    \"executionRoleArn\": \"$JOB_ROLE_ARN\", 
                    \"command\": [\"python\",\"app.py\"], 
                    \"logConfiguration\": {\"logDriver\": \"awslogs\",\"options\": {},\"secretOptions\": []}, 
                    \"secrets\": [], 
                    \"networkConfiguration\": {\"assignPublicIp\": \"ENABLED\"},
                    \"fargatePlatformConfiguration\": {\"platformVersion\": \"LATEST\"}, 
                    \"runtimePlatform\": {\"operatingSystemFamily\": \"LINUX\",\"cpuArchitecture\": \"X86_64\"}}" \
  --platform-capabilities FARGATE \
  --timeout '{"attemptDurationSeconds": 2400}' \
  --tags '{"epi:environment": "Prod","epi:product_stream": "coding","Department": "PET","epi:supported_by": "PET","epi:owner": "satadru1998@gmail.com","epi:team": "PET","Cost_Center_Name": "MCC_Ops_Tech_Licenses","Name": "Test Job Def"}' \
  --propagate-tags \
  --query "revision" )

echo "new_revision=$NEW_REVISION" >> $GITHUB_ENV     

# Delete Previous Job Definition
OLD_JOB_DEFINITION=arn:aws:batch:$AWS_DEFAULT_REGION:825865577047:job-definition/$JOB_NAME:$REVISION
aws batch deregister-job-definition --job-definition $OLD_JOB_DEFINITION

PREVIOUS_TO_PREVIOUS_JOB_DEFINITION=arn:aws:batch:$AWS_DEFAULT_REGION:825865577047:job-definition/$JOB_NAME:$((REVISION-1))
aws batch deregister-job-definition --job-definition $PREVIOUS_TO_PREVIOUS_JOB_DEFINITION
