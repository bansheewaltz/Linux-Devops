#!/bin/bash

image=monitoring2:dondarri

if [ ! "$(docker images -q $image)" ]; then
  docker build -t $image ubuntu .
fi

docker run -it --rm \
           -v "$PWD"/:/home/ \
           -w /home \
           -m 1712m \
           --name monitoring2_test \
           $image
