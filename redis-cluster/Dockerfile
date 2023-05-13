FROM redis:alpine
MAINTAINER Michał Dziuba <mail@michaldziuba.dev>

COPY setup.sh /
RUN chmod +x /setup.sh

EXPOSE 6000

ENTRYPOINT ["sh", "/setup.sh"]
