FROM public.ecr.aws/lambda/python:3.12

# Installing dependencies
RUN apk update && apk upgrade; \
    rm -rf /var/cache/apk/*; \
    pip install --upgrade pip --no-cache-dir ;

RUN apk --no-cache add gcc build-base

ARG env

# Copy function code
COPY lambda_handler.py ${LAMBDA_TASK_ROOT}
COPY requirements.txt  ${LAMBDA_TASK_ROOT}

# install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "lambda_handler.lambda_handler" ]
