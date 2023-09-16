#!/bin/bash

if [ "$1" = start ]; then
  docker build --tag ubuntu:runner - < Dockerfile.ci_runner 
  # docker run -p 22 --rm -ti --name u2 --network test ubuntu:v2 bash
  docker run --rm -itd -p 22 --network net --name runner \
    -v /Users/Shared/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner
  # docker exec -it runner bash -c 'ssh-keygen -t rsa -N "" -f /root/.ssh/vm_key && \
  #                                 sshpass -p1 ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/vm_key.pub root@vm && \
  #                                 bash'
  
fi

function allow_local_images {
  # source https://www.awaimai.com/en/3100.html
  docker exec -it gitlab-runner bash -c 'cat /etc/gitlab-runner/config.toml' > config.toml
  perl -pi -e '$_ .= qq(\t\tpull_policy = ["if-not-present", "always"]\n) if /\[runners.docker\]/' config.toml
  docker cp config.toml gitlab-runner:/etc/gitlab-runner
  rm config.toml
}
if [ "$1" = register ]; then
  docker run --rm -it \
    -v /Users/Shared/gitlab-runner/config:/etc/gitlab-runner \
    gitlab/gitlab-runner \
    register
  # interactive; otherwise, as example:
  # --url "https://gitlab.example.com/" \
  # --registration-token "PROJECT_REGISTRATION_TOKEN" \
  # --description "docker-ruby:2.6" \
  # --executor "docker" \
  # --template-config /tmp/test-config.template.toml \
  # --docker-image ruby:2.6
  allow_local_images
fi

if [ "$1" = rm ]; then
  docker container rm -f gitlab-runner
fi

if [ "$1" = vm ]; then
  docker run --rm -itd -p 22 --network net --name vm ubuntu:20.04
  docker exec -it vm bash -c 'apt update && \
                              DEBIAN_FRONTEND=noninteractive \
                              apt-get install -y openssh-server && \
                              echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
                              service ssh restart && \
                              echo "root:1" | chpasswd && \
                              bash'
fi
                              # sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
