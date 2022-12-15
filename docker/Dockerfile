FROM ubuntu:latest

ENV PR_MODE=1
ENV DEBUG=0

VOLUME /repo

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends tzdata vim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /linter-configs

COPY vendor vendor
COPY docker docker

COPY bin/install-deps.sh bin/install-deps.sh
RUN bin/install-deps.sh

COPY bin bin

COPY test test
COPY configs configs

WORKDIR /repo

ENTRYPOINT ["/linter-configs/docker/entry.normal.sh"]
