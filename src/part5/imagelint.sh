#!/bin/bash

if [ $# = 1 ]; then
  image_tag=$1
  dockerfile_suffix=.$image_tag
else
  image_tag=initial
fi

image_name=webserver
image=$image_name:$image_tag

docker build --tag "$image" -f Dockerfile"$dockerfile_suffix" .

# We will use Docker to use dockle command. Otherwise it won't work on ARM-based Macs
DOCKLE_LATEST=$(
 curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
 grep '"tag_name":' | \
 sed -E 's/.*"v([^"]+)".*/\1/' \
)
export DOCKLE_LATEST

# To scan the image on the host machine, we need to mount docker.sock
if [ ! "$image_tag" = secure ]; then
  # docker build --tag "$image" -f Dockerfile"$dockerfile_suffix" .
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
         goodwithtech/dockle:v${DOCKLE_LATEST} $image
else
  ### FATAL   - CIS-DI-0010: Do not store credential in environment variables/files
  ###         * Suspicious ENV key found : NGINX_GPGKEY and NGINX_GPGKEY_PATH
  # --accept-key value, --ak value 
  keys="-ak NGINX_GPGKEY -ak NGINX_GPGKEY_PATH"
  ### INFO    - CIS-DI-0005: Enable Content trust for Docker
  export DOCKER_CONTENT_TRUST=1
  # With this way of dockle invocation, setting the environment variable
  # DOCKER_CONTENT_TRUST=1 stops dockle from working because of not exisiting 
  # remote trust data.
  # So, I will use the way of dockle invocation with a .tar file, 
  # which works properly:
  docker save "$image" -o "$image_tag".tar
  dockle $keys --input "$image_tag".tar
  rm -rf "$image_tag".tar
fi
