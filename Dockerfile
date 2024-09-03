# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Copy the Python script into the container
COPY main.py .

# Set the default command to run the Python script
CMD ["python", "main.py"]
