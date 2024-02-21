echo "test"

#!/bin/bash
# terraform init
# Capture output from TF
# cd terraform_code
# echo $(terraform output ECS_TASK_EXECUTION_ROLE)
EXECUTION_ROLE_ARN=$(terraform output program_assessment_role_arn)
EXECUTION_ROLE_ARN=$(terraform output program_assessment_role_arn)
# ... (other Terraform output variables)

# Configure AWS Credentials
# aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
# aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
# aws configure set region $AWS_DEFAULT_REGION

# Capture ECR Repo and Image details

JOB_NAME=$(terraform output AWS_BATCH_JOB_NAME | tr -d '"')
# echo $JOB_NAME
ECR_REPO_NAME=$(terraform output ECR_REPO_NAME | tr -d '"')
# echo "JOB_NAME=${aws_batch_job_name}" >> $GITHUB_ENV
# echo "ECR_REPO_NAME=${ecr_repo_name}" >> $GITHUB_ENV
AWS_BATCH_JD_VCPU=$(terraform output aws_batch_JD_vcpu | tr -d '"')
# echo "AWS_BATCH_JD_VCPU=${aws_batch_JD_vcpu_processed}" >> $GITHUB_ENV
AWS_BATCH_JD_MEMORY=$(terraform output aws_batch_JD_memory | tr -d '"')
AWS_BATCH_JD_ARN=$(terraform output Batch_Job_Definition_ARN | tr -d '"')

# echo "AWS_BATCH_JD_MEMORY=${aws_batch_JD_memory_processed}" >> $GITHUB_ENV

# Get current JobDefinition revision

# REVISION=$(aws batch describe-job-definitions \
#   --job-definition-name $JOB_NAME  \
#   --status ACTIVE \
#   --query "jobDefinitions[0].revision")

# echo "revision=$REVISION" >> $GITHUB_ENV
# Get the current revision of the Job Definition
cd ../
ECR_IMAGE_TAG=$(cat env | grep ECR_IMAGE_TAG | cut -d'=' -f2)
cd terraform/
REVISION=$(aws batch describe-job-definitions \
  --job-definition-name $JOB_NAME \
  --status ACTIVE \
  --query "jobDefinitions[0].revision" \
  --output text)

if [ -z "$REVISION" ]; then
  echo "Failed to retrieve the current revision of the job definition."
  exit 1
fi

echo "Current revision: $REVISION"
img=$ECR_REPO_NAME:$ECR_IMAGE_TAG
# Register new JobDefinition
NEW_REVISION=$(aws batch register-job-definition \
  --job-definition-name $JOB_NAME \
  --type container \
  --parameters '{"p": "None"}' \
  --retry-strategy '{"attempts": 1,"evaluateOnExit": []}' \
  --container-properties "{\"image\" :\"$img\", 
                    \"resourceRequirements\": [{\"value\": \"$AWS_BATCH_JD_VCPU\",\"type\": \"VCPU\"},{\"value\": \"$AWS_BATCH_JD_MEMORY\",\"type\": \"MEMORY\"}], 
                    \"volumes\":[], 
                    \"environment\": [{\"name\": \"env_var\",\"value\": \"Prod\"}], 
                    \"mountPoints\": [], 
                    \"ulimits\": [], 
                    \"user\": \"root\", 
                    \"jobRoleArn\" : $EXECUTION_ROLE_ARN, 
                    \"executionRoleArn\": $EXECUTION_ROLE_ARN, 
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

new_revision=$NEW_REVISION

# Delete Previous Job Definition
OLD_JOB_DEFINITION=$AWS_BATCH_JD_ARN:$REVISION
aws batch deregister-job-definition --job-definition $JOB_NAME:$REVISION

# PREVIOUS_TO_PREVIOUS_JOB_DEFINITION=$JOB_NAME:$((REVISION-1))
# aws batch deregister-job-definition --job-definition $PREVIOUS_TO_PREVIOUS_JOB_DEFINITION

# Check if revision is greater than 1
if (( REVISION - 1 > 0 )); then
  # Construct the previous-to-previous job definition name
  PREVIOUS_TO_PREVIOUS_JOB_DEFINITION="$JOB_NAME:$((REVISION-1))"

  # Deregister the previous-to-previous job definition
  aws batch deregister-job-definition --job-definition "$PREVIOUS_TO_PREVIOUS_JOB_DEFINITION"
  echo "Deregistered job definition: $PREVIOUS_TO_PREVIOUS_JOB_DEFINITION"
else
  echo "Skipping deregistration: Revision 1 is not greater than 0"
fi
