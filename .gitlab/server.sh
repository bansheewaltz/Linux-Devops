#!/bin/bash

docker build --tag ubuntu:server - < server.Dockerfile
docker run --rm -d --name server --hostname server ubuntu:server
docker exec -it server bash -c 'cd /usr/local/bin && bash'
