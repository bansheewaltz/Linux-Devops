#!/bin/bash

if [ "$1" = clean ]; then
  rm -rf grafana prometheus
  docker-compose down
else
  mkdir -p prometheus grafana/provisioning/{dashboards,datasources}
  cp dashboard* grafana/provisioning/dashboards
  cp datasources.* grafana/provisioning/datasources
  docker-compose up -d
  docker exec -it test-env bash
fi
