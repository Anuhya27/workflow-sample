FROM public.ecr.aws/docker/library/python:3.11-alpine

# Installing dependencies
RUN apk update && apk upgrade; \
    rm -rf /var/cache/apk/*; \
    pip install --upgrade pip --no-cache-dir ;

RUN apk --no-cache add gcc build-base

ARG env

# Set the working directory in the container
WORKDIR /app

# Copy the files to working directory in the container
ADD . .

# Copy function code
COPY lambda_handler.py ${LAMBDA_TASK_ROOT}
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "lambda_handler.lambda_handler" ]
