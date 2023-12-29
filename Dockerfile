ARG POSTGRES_RELEASE=latest

FROM golang:1.21 as build

ARG WALG_RELEASE=master

RUN apt-get update && apt-get install -qqy --no-install-recommends --no-install-suggests cmake libbrotli-dev libsodium23 libsodium-dev && \
    cd /go/src/ && \
    git clone -b $WALG_RELEASE --recurse-submodules https://github.com/wal-g/wal-g.git && \
    cd wal-g && \
    GOBIN=/go/bin USE_BROTLI=1 USE_LIBSODIUM=1 make install_and_build_pg


FROM postgres:$POSTGRES_RELEASE

ENV WALG_COMPRESSION_METHOD=brotli

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -qqy curl ca-certificates libsodium23 vim

COPY --from=build /go/src/wal-g/main/pg/wal-g /usr/local/bin/wal-g
COPY scripts /scripts

USER postgres

CMD ["/scripts/start.sh"]
