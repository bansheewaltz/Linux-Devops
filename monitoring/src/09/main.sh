#!/bin/bash

# data=data.html
# docker rm -f nginx
# docker run --rm -d --name nginx -v ./:/static -p 8081:80 flashspys/nginx-static

while true
do
    bash export.sh > metrics
    sleep 3;
done
