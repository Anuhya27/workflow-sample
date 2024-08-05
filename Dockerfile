FROM public.ecr.aws/lambda/python:3.12

# Installing dependencies
RUN yum -y update && yum -y upgrade; \
    yum clean all; \
    pip install --upgrade pip --no-cache-dir ;

# Install gcc and build-base using yum
RUN yum -y install gcc gcc-c++ make

ARG env

# Copy function code
COPY lambda_handler.py ${LAMBDA_TASK_ROOT}
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "lambda_handler.lambda_handler" ]
