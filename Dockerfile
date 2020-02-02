FROM alpine:3.9 as build

RUN apk update && \
        apk add \
            tar \
            ip6tables \
            build-base \
            coreutils \
            git \
            protobuf-c-dev \
            protobuf-dev \
            python \
            libaio-dev \
            libcap-dev \
            libnl3-dev \
            pkgconfig \
            libnet-dev \
            ccache \
            gcc \
            patchelf

RUN wget http://download.openvz.org/criu/criu-3.13.tar.bz2 && \
        tar -xjf criu-3.13.tar.bz2 && \
        mv criu-*/ criu && \
        rm criu-*.bz2

WORKDIR /criu

RUN make

RUN patchelf --set-interpreter /criu/ld-musl-x86_64.so.1 --set-rpath /criu criu/criu

RUN patchelf --replace-needed libc.musl-x86_64.so.1 ld-musl-x86_64.so.1 criu/criu

FROM ubuntu

COPY --from=build \
        /criu/criu/criu \
        /lib/ld-musl-x86_64.so.1 \
        /usr/lib/libnl-3.so.200 \
        /usr/lib/libprotobuf-c.so.1 \
        /usr/lib/libnet.so.1 \
        /criu/
