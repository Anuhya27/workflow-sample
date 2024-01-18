FROM --platform=linux/arm64 python:3.10 as build
# FROM python:3.10
COPY batch_app.py .
CMD ["python", "batch_app.py", "--user_input", "hello_from_docker"]