#!/bin/bash

if [ $# = 0 ]; then
  echo no args provided; exit 0; fi


if [ "$1" = start ]; then
  docker build --tag ubuntu:runner - < Dockerfile.ci_runner 
  docker run --rm -it --name runner \
             -v /Users/Shared/gitlab-runner/config:/etc/gitlab-runner \
             -v /var/run/docker.sock:/var/run/docker.sock \
             gitlab/gitlab-runner
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

if [ "$1" = server ]; then
  docker build --tag ubuntu:server - < Dockerfile.server
  docker run --rm -d --name server --hostname server ubuntu:server
  docker exec -it server bash -c 'cd /usr/local/bin && bash'
fi
