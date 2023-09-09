#!/bin/bash

image_name=ubuntu_wt:dondarri

if ! docker image inspect $image_name >/dev/null 2>&1; then
  docker build -t $image_name - < Dockerfile
fi

docker run -it --rm \
           -v "$PWD"/:/home/ \
           -w /home \
           -m 3117m \
           -e TZ=Asia/Novosibirsk \
           --name monitoring2_dondarri \
           $image_name
