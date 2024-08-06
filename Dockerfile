# Base image
FROM public.ecr.aws/lambda/python:3.12-x86_64

# # Installing dependencies
# RUN apk update && apk upgrade; \
#     rm -rf /var/cache/apk/*; \
#     pip install --upgrade pip --no-cache-dir ;

# RUN apk --no-cache add gcc build-base

# Install build dependencies
# RUN apt-get update \
#     && apt-get install -y gcc g++ make \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

COPY requirements.txt  ${LAMBDA_TASK_ROOT}
# Copy the files to working directory in the container
COPY lambda_handler.py ${LAMBDA_TASK_ROOT}
COPY analysis-sheets-36029f131547.json ${LAMBDA_TASK_ROOT}

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Run script.py when the container launches
CMD [ "lambda_handler.lambda_handler" ]
