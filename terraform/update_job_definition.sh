#!/bin/bash

EXECUTION_ROLE_ARN=$(terraform output iam_role_arn | tr -d '"')
JOB_NAME=$(terraform output AWS_BATCH_JOB_NAME | tr -d '"')
ECR_REPO_NAME=$(terraform output ECR_REPO_NAME | tr -d '"')
AWS_BATCH_JD_VCPU=$(terraform output aws_batch_JD_vcpu | tr -d '"')
AWS_BATCH_JD_MEMORY=$(terraform output aws_batch_JD_memory | tr -d '"')
AWS_BATCH_JD_ARN=$(terraform output Batch_Job_Definition_ARN | tr -d '"')
TAG_ENVIRONMENT=$(terraform output Tag_environment | tr -d '"')
TAG_NAME=$(terraform output Tag_name | tr -d '"')

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

img=$ECR_REPO_NAME:$ECR_IMAGE_TAG

NEW_REVISION=$(aws batch register-job-definition \
  --job-definition-name $JOB_NAME \
  --type container \
  --parameters '{"p": "None"}' \
  --retry-strategy '{"attempts": 1,"evaluateOnExit": []}' \
  --container-properties "{\"image\" :\"$img\",
                    \"resourceRequirements\": [{\"value\": \"$AWS_BATCH_JD_VCPU\",\"type\": \"VCPU\"},{\"value\": \"$AWS_BATCH_JD_MEMORY\",\"type\": \"MEMORY\"}],
                    \"jobRoleArn\" : \"$EXECUTION_ROLE_ARN\",
                    \"executionRoleArn\": \"$EXECUTION_ROLE_ARN\",
                    \"command\": [\"echo\",\"Starting Program assessment...\"],
                    \"fargatePlatformConfiguration\": {\"platformVersion\": \"LATEST\"},
                    \"runtimePlatform\": {\"operatingSystemFamily\": \"LINUX\",\"cpuArchitecture\": \"X86_64\"}}" \
  --platform-capabilities FARGATE \
  --tags "{\"epi:environment\": \"$TAG_ENVIRONMENT\",\"epi:product_stream\": \"analyst\",\"Department\": \"PET\",\"epi:supported_by\": \"PET\",\"epi:owner\": \"gowtham.veerappan@episource.com\",\"epi:team\": \"PET\",\"Cost_Center_Name\": \"EpiAnalyst_Ops_Tech_Licenses\",\"Name\": \"$TAG_NAME\"}" \
  --query "revision" )

echo "Registered job definition: $NEW_REVISION with ECR image tag: $img"

new_revision=$NEW_REVISION

# Delete Previous Job Definition
OLD_JOB_DEFINITION=$AWS_BATCH_JD_ARN:$REVISION
aws batch deregister-job-definition --job-definition $JOB_NAME:$REVISION
echo revision $REVISION
# Check if revision is greater than 1
if (( REVISION - 1 > 0 )); then

  # Construct the previous-to-previous job definition name
  PREVIOUS_TO_PREVIOUS_JOB_DEFINITION="$JOB_NAME:$((REVISION-1))"

  # Deregister the previous-to-previous job definition
  aws batch deregister-job-definition --job-definition "$PREVIOUS_TO_PREVIOUS_JOB_DEFINITION"
  echo "Deregistered job definition: $PREVIOUS_TO_PREVIOUS_JOB_DEFINITION"
fi
