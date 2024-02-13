#!/bin/bash

### General daemon installation and configuration process
# 1. Install as usual; following standard Linux conventions, create a directory 
# with the corresponding name in /etc for configuration files and a directory 
# in /var/lib for its data.
# 2. Create a new user/group for a new daemon application, use the
# --no-create-home and --shell /bin/false so that that the user can’t log 
# into the system and --system so it has the uid from the system id pool.
# 3. Change an ownership of a varaible data belonging to the daemon application
# 4. In a case of using a full-fledged system or a VM, i.e., not Docker 
# container, configure the script for the init-system used on the system

### Installation of prometheus
# donwnload and extract 
wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-arm64.tar.gz
tar xvfz prometheus-*.tar.gz
rm -rf prometheus-*.tar.gz
cd prometheus-* || exit 1
# Create a new user:group for the daemon application.
mkdir -p /etc/prometheus
mkdir -p /var/lib/prometheus
# Copy the two binaries.
cp promtool   /usr/local/bin/
cp prometheus /usr/local/bin/
# Copy the two directories.
cp -r consoles /etc/prometheus
cp -r console_libraries /etc/prometheus
cd ..
# Create the symlink for the configuration file
ln -s "$PWD"/prometheus.yml /etc/prometheus/prometheus.yml
# Remove the leftover files as they are no longer needed.
rm -rf prometheus-*
# Using the -R flag will ensure that ownership is set on the files inside.
useradd --system --no-create-home --shell /bin/false prometheus
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
chown prometheus:prometheus /var/lib/prometheus
chown -R prometheus:prometheus /etc/prometheus

### Installation of node-exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-arm64.tar.gz
tar xvfz node_exporter-*.tar.gz
cp node_exporter-*/node_exporter /usr/local/bin
rm -rf node_exporter-*
useradd --system --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter


### Installation of grafana
apt update
apt install -y adduser libfontconfig1 musl
# wget https://dl.grafana.com/oss/release/grafana-10.1.1.linux-arm64.tar.gz
wget https://dl.grafana.com/oss/release/grafana_10.1.1_arm64.deb
dpkg -i grafana_10.1.1_arm64.deb
rm -rf grafana_*
