import boto3
import json
import requests
import pandas as pd
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
    
def lambda_handler(event, context):
    s3_bucket = 'ecr-sync'
    s3_key = 'analysis-sheets-36029f131547.json'

    # Initialize S3 client
    s3_client = boto3.client('s3')

    # Fetch the JSON file from S3
    try:
        response = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
        json_data = response['Body'].read().decode('utf-8')
        creds_json = json.loads(json_data)
    except Exception as e:
        print(f"Error fetching JSON file from S3: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error fetching JSON file from S3: {e}')
        }
    
    # Set up credentials
    # creds_dict = json.loads(creds_json)
    # scopes = ['https://www.googleapis.com/auth/cloud-platform']

    scopes = ['https://www.googleapis.com/auth/spreadsheets.readonly']
    creds = Credentials.from_service_account_info(creds_json, scopes=scopes)
    
    # Build the service
    service = build('sheets', 'v4', credentials=creds)
    
    # Spreadsheet ID and range
    spreadsheet_id = '17DNAKfvOICZlV7w7E3fJKQce4PYRxwEtTkRioTDGSzc'
    range_name = 'Sheet1!A1:D10'  # Adjust this to your desired range
    
    # Call the Sheets API
    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=spreadsheet_id, range=range_name).execute()
    values = result.get('values', [])
    
    # Convert to pandas DataFrame
    df = pd.DataFrame(values[1:], columns=values[0])
    
    # Display the DataFrame
    print(df)
    source_region = 'us-west-2'
    dest_region = 'us-east-1'
    slack_webhook_url = "https://hooks.slack.com/services/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"  # Replace with your Slack Webhook URL

    source_ecr = boto3.client('ecr', region_name=source_region)
    dest_ecr = boto3.client('ecr', region_name=dest_region)

    response = source_ecr.describe_repositories()
    source_repos = [repo['repositoryName'] for repo in response['repositories']]
    
    deleted_images_report = {}

    for repo_name in source_repos:
        print(f"Started processing: {repo_name}")

        try:
            dest_ecr.describe_repositories(repositoryNames=[repo_name])
        except dest_ecr.exceptions.RepositoryNotFoundException:
            print(f"{repo_name} not found in destination.")
            continue  

        try:
            source_images_response = source_ecr.list_images(repositoryName=repo_name)
            source_images = source_images_response['imageIds']

            source_image_tags = {image['imageTag'] for image in source_images if 'imageTag' in image}

            print("source_image_tags", source_image_tags)
            dest_images_response = dest_ecr.list_images(repositoryName=repo_name)
            dest_images = dest_images_response['imageIds']
            
            dest_image_tags = {image['imageTag'] for image in dest_images if 'imageTag' in image}
            print("dest_image_tags", dest_image_tags)

            extra_image_tags = dest_image_tags - source_image_tags
            print("extra_image_tags", extra_image_tags)

            extra_images = [{'imageTag': image['imageTag']} for image in dest_images if 'imageTag' in image and image['imageTag'] in extra_image_tags]
            if extra_images:
                print(f"Deleting extra images from {repo_name}: {extra_images}")
                
                delete_response = dest_ecr.batch_delete_image(repositoryName=repo_name, imageIds=extra_images)
                print(f"Delete response for {repo_name}: {delete_response}")

                if 'failures' not in delete_response or not delete_response['failures']:
                    # Collect deleted image tags for Slack notification
                    deleted_tags = [image['imageTag'] for image in extra_images]
                    deleted_images_report[repo_name] = ', '.join(deleted_tags)
        
        except Exception as e:
            print(f"Error processing {repo_name}: {e}")
            continue
    
    # Send Slack notification if there are deleted images
    if deleted_images_report:
        # Create the header and affected repos section
        blocks = [
            {"type": "divider"},  # Add a divider on top
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": ":hammer_and_wrench: *ECR Replica Sync* :rocket:"  # Add an emoji to the header
                },
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "*Affected Repos:*"
                },
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "\n".join([f"• *{repo}*: `{tags}`" for repo, tags in deleted_images_report.items()])
                },
            },
        ]
    
        # Create the payload
        payload = {
            "blocks": blocks
        }
    
        try:
            response = requests.post(slack_webhook_url, data=json.dumps(payload), headers={'Content-Type': 'application/json'})
            if response.status_code == 200:
                print("Slack notification sent successfully.")
            else:
                print(f"Failed to send Slack notification: {response.status_code}, {response.text}")
        except Exception as e:
            print(f"Error sending Slack notification: {e}")

    return {
        'statusCode': 200,
        'body': json.dumps('ECR sync completed successfully.')
    }
