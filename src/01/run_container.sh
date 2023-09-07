#!/bin/bash

docker run -it --rm \
           -v "$PWD"/:/home/ \
           -w /home \
           -m 1112m \
           --name monitoring2_dondarri \
           ubuntu

rm -rf $(find . -name "logfile*")
