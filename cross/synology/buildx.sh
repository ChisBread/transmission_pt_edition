#!/usr/bin/env bash
sudo docker buildx build --push --platform=linux/amd64,linux/arm/v7,linux/arm64/v8 --tag chisbread/transmission:synology --tag chisbread/transmission:synology-r13 .
