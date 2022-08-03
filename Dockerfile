from python:3.10

WORKDIR /src

COPY . .

RUN pip install -r requirements.txt

ENTRYPOINT ["python", "/src/main.py"]
