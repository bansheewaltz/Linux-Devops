#!/bin/bash

docker run -it --rm \
           -v "$PWD"/..:/home/ \
           -w /home \
           -m 5117m \
           --name monitoring2_dondarri \
           ubuntu
