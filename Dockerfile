FROM alpine:latest
WORKDIR /app
COPY ./ /app

RUN chown -R 1000 /app
