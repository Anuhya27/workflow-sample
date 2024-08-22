# Base image
FROM public.ecr.aws/lambda/python:3.12-x86_64

# RUN apt-get update \
#     && apt-get install -y gcc g++ make \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

COPY requirements.txt  ${LAMBDA_TASK_ROOT}
# Copy the files to working directory in the container

COPY config.ini ${LAMBDA_TASK_ROOT}
COPY lambda_handler.py ${LAMBDA_TASK_ROOT}


# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
# Run script.py when the container launches
CMD [ "lambda_handler.lambda_handler" ]


# # Use the official Python image from the Docker Hub
# FROM python:3.9-slim

# # Set the working directory in the container
# WORKDIR /app

# # Copy the Python script into the container
# COPY ecr.py .

# # Set the default command to run the Python script
# CMD ["python", "ecr.py"]
