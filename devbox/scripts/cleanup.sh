#!/bin/bash

###############################################################################
# Remove build proxy settings and put in run proxy, if any                    #
###############################################################################

# Delete proxy entries (that may come from a proxy that was set for building this image)
sed -i '/Acquire::http::proxy/d' /etc/apt/apt.conf.d/70debconf

if [ -n "$run_proxy" ]; then
  # Put in the proxy we want this machine to run with
  echo "http_proxy=${run_proxy}" >> /etc/environment
  echo "https_proxy=${run_proxy}" >> /etc/environment
  echo "Acquire::http::proxy \"${run_proxy}\";" >> /etc/apt/apt.conf.d/70debconf
fi

###############################################################################
# Cleanup taken from github.com/hashicorp/atlas-packer-vagrant-tutorial       #
###############################################################################

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

# Make sure Udev doesn't block our network
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces