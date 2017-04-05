FROM elixir:1.4.2

ENV PORT 8080
ENV VERSION 0.0.1

WORKDIR /var/www/

COPY docker/start.sh .
COPY _build/prod/rel/dashboard/releases/$VERSION/dashboard.tar.gz .

RUN tar -xzf dashboard.tar.gz && \
    apt-get update && apt-get install python3-pip -y && pip3 install awscli

EXPOSE $PORT

CMD ["./start.sh"]
