#! /bin/bash
TR_ROOT="$(cd "$(dirname "$0")";cd ..;pwd)"
mkdir -p $TR_ROOT/cross/build
sudo docker run -e BUILD_PREFIX="amd64" -v $TR_ROOT:/src -it chisbread/alpine-trbuilder:latest /src/cross/incontainer.sh
sudo docker run -e BUILD_PREFIX="arm64" -v $TR_ROOT:/src -it chisbread/alpine-trbuilder:arm64v8-latest /src/cross/incontainer.sh
sudo docker run -e BUILD_PREFIX="armv7" -v $TR_ROOT:/src -it chisbread/alpine-trbuilder:arm32v7-latest /src/cross/incontainer.sh
cd $TR_ROOT
sudo docker buildx build --push --platform=linux/amd64,linux/arm/v7,linux/arm64/v8 --tag chisbread/transmission:version-3.00-r12 --tag chisbread/transmission:latest -f cross/Dockerfile.buildx --no-cache .