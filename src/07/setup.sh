#!/bin/bash

### Install prometheus
# Creating a new group/user for a new installed daemon improves security.
# Use the --no-create-home and --shell /bin/false so that that the user 
# can’t log into the server and --system so it has the uid from system id pool.
useradd --system --no-create-home --shell /bin/false prometheus
# Following standard Linux conventions, we’ll create a directory in /etc 
# for Prometheus’ configuration files and a directory in /var/lib for its data.
mkdir -p /var/lib/prometheus
mkdir -p /etc/prometheus
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
## We can now download Prometheus and then create the configuration file.
wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-arm64.tar.gz
tar xvfz prometheus-*.tar.gz
rm -rf prometheus-*.tar.gz
cd prometheus-* || exit 1
# Copy the two binaries.
cp promtool   /usr/local/bin/
cp prometheus /usr/local/bin/
# Copy the two directories.
cp -r consoles /etc/prometheus
cp -r console_libraries /etc/prometheus
# Using the -R flag will ensure that ownership is set on the files inside.
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
# Remove the leftover files as they are no longer needed.
cd ..; rm -rf prometheus-*

### Install node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-arm64.tar.gz -O - | tar -xzv -C ./
cp node_exporter-1.3.1.linux-arm64/node_exporter /usr/local/bin

### Install grafana
apt install -y software-properties-common wget apt-transport-https
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
apt update && apt -y install grafana
cp prometheus2.yml /etc/grafana/provisioning/datasources/prometheus.yml 
rm -rf node_exporter-1.3.1.linux-arm64 prometheus-2.35.0.linux-amd64

# Reload the systemd configuraiton and start the daemons
systemctl daemon-reload
systemctl start prometheus.service
systemctl start node_exporter.service
systemctl start grafana-server.service
