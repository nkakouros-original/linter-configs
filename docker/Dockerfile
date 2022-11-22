FROM ubuntu:latest

ENV LATEST_COMMIT_ONLY=1
ENV DEBUG=0

VOLUME /repo

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends tzdata

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /linter-configs

COPY vendor vendor

COPY docker docker
COPY bin bin
RUN bin/install-deps.sh

COPY configs configs
COPY test test

ENTRYPOINT ["/linter-configs/docker/entry.normal.sh"]
