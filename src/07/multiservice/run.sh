#!/bin/bash

runuser -u prometheus -- \
prometheus --config.file /etc/prometheus/prometheus.yml \
           --storage.tsdb.path /var/lib/prometheus \
           --web.console.templates=/etc/prometheus/consoles \
           --web.console.libraries=/etc/prometheus/console_libraries \
           > prometheus.log 2>&1 &

service grafana-server start >/dev/null

runuser -u node_exporter -- \
/usr/local/bin/node_exporter > prometheus.log 2>&1 &
