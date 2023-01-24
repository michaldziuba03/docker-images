FROM mongo:6
MAINTAINER Michał Dziuba <mail@michaldziuba.dev>

COPY ./setup.sh /
RUN chmod +x /setup.sh

ENV MONGO_NODES="27017"

EXPOSE 27017

ENTRYPOINT ["bash", "setup.sh"]
