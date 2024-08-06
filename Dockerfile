# Base image
FROM public.ecr.aws/docker/library/python:3.11-alpine

# Installing dependencies
RUN apk update && apk upgrade; \
    rm -rf /var/cache/apk/*; \
    pip install --upgrade pip --no-cache-dir ;

RUN apk --no-cache add gcc build-base

COPY requirements.txt  ${LAMBDA_TASK_ROOT}
# Copy the files to working directory in the container
COPY lambda_handler.py ${LAMBDA_TASK_ROOT}

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Run script.py when the container launches
CMD [ "lambda_handler.lambda_handler" ]
