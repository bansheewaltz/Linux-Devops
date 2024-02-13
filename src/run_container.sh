#!/bin/bash

image_name=ubuntu_monitoring:dondarri

if ! docker image inspect $image_name >/dev/null 2>&1; then
  docker build -t $image_name - < Dockerfile
fi

### port mapping
# 80:80 for goaccess
# 3000:3000 for grafana
# 9090:9090 for prometheus
# 9100:9100 for node-exporter
docker run --interactive \
           --tty \
           --volume "$PWD"/:/home/ \
           --workdir /home \
           --memory 3117m \
           --env TZ=Asia/Novosibirsk \
           --publish 80:80 \
           --publish 3000:3000 \
           --publish 9090:9090 \
           --publish 9100:9100 \
           --name DO4_dondarri \
           $image_name
