#!/usr/bin/env bash

rm criu.iso

set -e

docker build -t foo .
docker create --name=lol foo nop
docker cp lol:/criu.iso criu.iso
docker rm lol