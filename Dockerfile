FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y wget

RUN wget http://download.openvz.org/criu/criu-3.12.tar.bz2
RUN tar -xjf criu-3.12.tar.bz2

WORKDIR /criu-3.12

RUN apt-get install -y \
    build-essential \
    cmake \
    musl-dev \
    musl-tools

RUN apt-get install -y libprotobuf-dev libprotobuf-c0-dev protobuf-c-compiler protobuf-compiler python-protobuf
RUN apt-get install -y libbsd-dev gcc-multilib pkgconf
RUN apt-get install -y python-ipaddress iproute2 libcap-dev libnl-3-dev libnet-dev libaio-dev