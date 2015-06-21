#!/bin/bash

###############################################################################
# TODO Setup iptables                                                         #
# TODO                                                                        #
###############################################################################

set -eu

###############################################################################
# Perform base installation                                                   #
###############################################################################

export DEBIAN_FRONTEND=noninteractive

# Install required packages
apt-get update
apt-get -y upgrade

# Install required packages
apt-get -y install \
           wget \
           curl \
           vim \
           unzip \
           screen \
           htop \
           iotop
           
# Create user consul
useradd --home /home/consul --create-home --groups sudo --shell /bin/bash consul

# Setup sudo for our user
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

# Disable DNS lookup for SSH connections (causes 10s delay if not deactivated)
echo "UseDNS no" >> /etc/ssh/sshd_config

