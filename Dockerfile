FROM elixir:1.4.2

ENV PORT 8080
ENV VERSION 0.0.1

WORKDIR /var/www/

COPY _build/prod/rel/dashboard/releases/$VERSION/dashboard.tar.gz .

RUN tar -xzf dashboard.tar.gz

EXPOSE $PORT

CMD ["/var/www/bin/dashboard", "foreground"]
