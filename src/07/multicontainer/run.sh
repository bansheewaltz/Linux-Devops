#!/bin/bash

if [ "$1" = clean ]; then
  docker-compose down
  sudo rm -rf grafana prometheus
else
  mkdir --parents prometheus grafana/provisioning/{dashboards,datasources}
  cp dashboard* grafana/provisioning/dashboards
  cp datasources.* grafana/provisioning/datasources
  chmod -R 777 grafana
  sudo chown -R 65534:65534 prometheus
  docker-compose up --force-recreate --detach #--abort-on-container-exit
  docker exec --interactive --tty test-env bash
fi
