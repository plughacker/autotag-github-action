from python:3.10

COPY . .

RUN pip install -r requirements.txt

ENTRYPOINT ["python", "main.py"]
