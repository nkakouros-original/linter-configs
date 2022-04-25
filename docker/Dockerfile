FROM ubuntu:latest

VOLUME /repo

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends tzdata

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /linter-configs

COPY install-deps.sh .
COPY vendor vendor

RUN ./install-deps.sh

COPY configs configs
COPY docker docker
COPY test test

ENTRYPOINT ["/linter-configs/docker/entry.normal.sh"]
