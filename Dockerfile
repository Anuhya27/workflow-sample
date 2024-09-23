FROM python:3.11-alpine   

# Installing dependencies
RUN apk update && apk upgrade; \
    rm -rf /var/cache/apk/*; \
    pip install --upgrade pip --no-cache-dir ;

RUN apk --no-cache add gcc build-base


# Copy the files to working directory in the container
WORKDIR /app

# Copy the files to working directory in the container
COPY requirements.txt  .
COPY main.py .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Run script.py when the container launches
CMD ["python", "main.py"]

