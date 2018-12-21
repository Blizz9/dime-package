# this is the base docker image (from dockerhub.com) that will be used for our app's container
FROM debian:latest

# this copies all of the files into the container, whole-cloth
COPY ./ /usr/local/bin/dime-package/

# some necessary OS updates to support Python
RUN apt-get update && apt-get install -y \
    build-essential libffi-dev libssl-dev python python-dev libpython-dev python-pip && \
    pip install --upgrade pip

# some Python packages we are using
RUN pip install flask && pip install psycopg2-binary && pip install requests && pip install sportsreference

# this is the port our app is being served on and allows it to communicate out of the container
EXPOSE 80

# the command that is run when the container begins, starting our app
CMD ["python", "/usr/local/bin/dime-package/app.py"]
