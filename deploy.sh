#!/bin/bash

ssh-keygen -t rsa -N "" -f /root/.ssh/vm_key
# vm_ip=$(docker inspect \
#   -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id)
vm=172.17.0.2
sshpass -p1 ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/vm_key.pub root@$vm

BIN_DIR=build/bin
scp -i ~/.ssh/vm_key $BIN_DIR/* root@$vm:/usr/local/bin
