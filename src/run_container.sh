#!/bin/bash

image_name=ubuntu_webwt:dondarri

if ! docker image inspect $image_name >/dev/null 2>&1; then
  docker build -t $image_name - < Dockerfile
fi

docker run --interactive \
           --tty \
           --rm \
           --volume "$PWD"/:/home/ \
           --workdir /home \
           --memory 3117m \
           --env TZ=Asia/Novosibirsk \
           --publish 80:80 \
           --name DO4_dondarri \
           $image_name
