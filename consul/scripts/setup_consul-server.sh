#!/bin/bash

set -e

###############################################################################
# Perform consul setup for bootstrap instance                                 #
###############################################################################

# Donwload consul
cd /usr/local/bin
wget -O consul.zip https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip
unzip consul.zip
rm consul.zip

# Setup consul
mkdir -p /etc/consul.d/server
mkdir /var/consul
chown consul:consul /var/consul

cat <<EOF >/tmp/server
{
    "bootstrap": false,
    "server": true,
    "datacenter": "do-fra1",
    "data_dir": "/var/consul",
    "encrypt": "F1UPXmr1jwmqbo0kC4Rwpw==",
    "log_level": "INFO",
    "enable_syslog": true,
    "start_join": ["192.0.2.2", "192.0.2.3"]
}
EOF
mv /tmp/server /etc/consul.d/server/config.json


cat <<EOF >/tmp/consul.server.service
[Unit]
Description=Consul Agent
Wants=basic.target
After=basic.target network.target

[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir /etc/consul.d/server
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
EOF
mv /tmp/consul.server.service /etc/systemd/system/consul.server.service

