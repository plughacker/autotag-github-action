from python:3.10

WORKDIR /src

COPY . .

RUN pip install -r requirements.txt

RUN PYTHONUNBUFFERED=1

ENTRYPOINT ["python", "-u", "/src/main.py"]
