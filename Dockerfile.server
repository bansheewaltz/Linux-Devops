FROM ubuntu:20.04

RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y openssh-server; \
                       sshpass; \
    rm -rf /var/lib/apt/lists/*; \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config; \
    echo "root:1" | chpasswd

ENTRYPOINT service ssh start && tail -f /dev/null
