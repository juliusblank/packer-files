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
mkdir -p /etc/consul.d/bootstrap
mkdir /var/consul
chown consul:consul /var/consul

cat <<EOF >/tmp/bootstrap
{
    "bootstrap": true,
    "server": true,
    "datacenter": "do-fra1",
    "data_dir": "/var/consul",
    "encrypt": "F1UPXmr1jwmqbo0kC4Rwpw==",
    "log_level": "INFO",
    "enable_syslog": true
}
EOF
mv /tmp/bootstrap /etc/consul.d/bootstrap/config.json

