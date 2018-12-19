FROM debian:latest

COPY ./ /usr/local/bin/football/

RUN apt-get update && apt-get install -y \
    build-essential libffi-dev libssl-dev python python-dev libpython-dev python-pip && \
    pip install --upgrade pip

RUN pip install flask && pip install psycopg2 && pip install requests

EXPOSE 80

CMD ["python", "/usr/local/bin/football/app.py"]
