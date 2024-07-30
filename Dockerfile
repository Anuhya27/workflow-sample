# ARG AWS_ACCOUNT_ID

# FROM --platform=linux/arm64 python:3.10 as build
FROM python:3.10

COPY  requirements.txt .
# CMD ["python", "batch_app.py", "--user_input", "hello_from_docker"]
CMD ["echo", "JOB_DEFINITION:$JOB_DEFINITION"]
