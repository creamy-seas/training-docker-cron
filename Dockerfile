FROM ubuntu:latest
MAINTAINER ilya.antonov@dreams-ai.com

ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get -y install cron python3.7 python3-pip

COPY * /core/

COPY .env /etc/environment

COPY cron-file /etc/cron.d/cron-file-in-docker
RUN chmod 0644 /etc/cron.d/cron-file-in-docker
RUN crontab /etc/cron.d/cron-file-in-docker
RUN touch /var/log/cron.log
