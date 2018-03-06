FROM elixir:1.6-alpine as build

WORKDIR /var/www/

COPY . .

RUN apk add -U nodejs git
RUN npm install --prefix assets && \
    mix do local.hex --force, local.rebar --force, deps.get --only prod && \
    npm run build --prefix assets && \
    MIX_ENV=prod mix do phx.digest, release


FROM alpine:3.7

ENV PORT 8080
ENV VERSION 0.0.1
WORKDIR /var/www/

COPY --from=build /var/www/_build/prod/rel/dashboard/releases/$VERSION/dashboard.tar.gz .

RUN apk add -U bash openssl && \
    tar -xzf dashboard.tar.gz && \
    rm -f dashboard.tar.gz

EXPOSE $PORT

CMD ["./bin/dashboard", "foreground"]

