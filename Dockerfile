FROM python:2.7.10-slim
MAINTAINER Gerry G <gobind99@gmail.com>

#fix missing removes all broken possible things and noinstallrecommends gets rid of extra stuff, build essential adds any # missing stuff to use for building
RUN apt-get update && apt-get install -qq -y build-essential libpq-dev postgresql-client --fix-missing --no-install-recommends

ENV INSTALL_PATH /mobydock
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# copy into current directory into current directory since we use variable INSTALL_PATH 
# this copies everything into the docker container other than whats specified in dockerignore
# everything is layered so this is more efficient
COPY . .

# created for NGINX which is going to serve all our static content
VOLUME ["static"]

# gunicorn server listens on anyhost create_app function which is the app factory pattern
CMD gunicorn -b 0.0.0.0 "mobydock.app:create_app()"

