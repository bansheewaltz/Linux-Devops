#!/bin/bash

if [ "$1" = clean ]; then
  rm -rf grafana prometheus;
else
  mkdir -p prometheus grafana/provisioning
fi
