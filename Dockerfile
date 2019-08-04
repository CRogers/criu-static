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
            gcc

RUN wget http://download.openvz.org/criu/criu-3.12.tar.bz2
RUN tar -xjf criu-3.12.tar.bz2

WORKDIR /criu-3.12

RUN make

RUN apk add cdrkit

WORKDIR /

RUN mkdir -p /criu-iso/usr/lib

RUN cp criu-3.12/criu/criu criu-iso && cp \ 
        /usr/lib/libnl-3.so.200 \
        /usr/lib/libprotobuf-c.so.1 \
        /usr/lib/libnet.so.1 \
        /criu-iso/usr/lib

RUN mkisofs -allow-lowercase -o /criu.iso /criu-iso
