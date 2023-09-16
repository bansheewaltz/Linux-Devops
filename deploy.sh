#!/bin/bash

ssh-keygen -t rsa -N "" -f /root/.ssh/vm_key
sshpass -p1 ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/vm_key.pub root@vm

BIN_DIR=build/bin
scp $BIN_DIR/* root@vm:/usr/local/bin
