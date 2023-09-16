#!/bin/bash

ssh-keygen -t rsa -N "" -f /root/.ssh/server_key
# server_ip=$(docker inspect \
#   -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id)
server=172.17.0.3
sshpass -p1 ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/server_key.pub root@$server

BIN_DIR=build/bin
scp -i ~/.ssh/server_key $BIN_DIR/* root@$server:/usr/local/bin
