#! /bin/bash
sudo docker build -t chisbread/alpine-trbuilder:latest . &
sudo docker build -t chisbread/alpine-trbuilder:arm64v8-latest -f Dockerfile.arm64 . &
sudo docker build -t chisbread/alpine-trbuilder:arm32v7-latest -f Dockerfile.armv7 . &
wait