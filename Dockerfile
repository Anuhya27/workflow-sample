FROM --platform=linux/amd64 python:3.10
COPY batch_app.py .
CMD ["python", "batch_app.py", "--user_input", "hello_from_docker"]