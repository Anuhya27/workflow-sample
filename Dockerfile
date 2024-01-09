FROM python:3.10
WORKDIR /first_cluster
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY test.py .
CMD [ "python", "./test.py"]