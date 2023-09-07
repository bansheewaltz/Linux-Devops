#!/bin/bash

docker run -it --rm \
           -v "$PWD"/:/home/ \
           -w /home \
           -m 3117m \
           --name monitoring2_dondarri \
           ubuntu

rm -rf $(find . -name "logfile*")
