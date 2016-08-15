#!/bin/bash

###############################################################################
# TODO Setup packer for validating templates                                  #
# TODO Setup ~/.bashrc                                                        #
# TODO Setup iptables                                                         #
# TODO Keys?                                                                  #
# TODO Update this script according to the new 15.04 script from work         #
# TODO Setup azure-cli (container with systemd-unit (systemd-docker)          #
# TODO Setup mesosphere dcos                                                  #
# TODO Setup Google Cloud SDK                                                                       #
###############################################################################

set -e

# Enable debug if set
if [ ! -z "${DEBUG}" ]; then
  set -x
fi

###############################################################################
# Perform base installation                                                   #
###############################################################################

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y upgrade

# Install required packages
apt-get -y install \
           linux-image-extra-$(uname -r) \
           linux-image-extra-virtual\
           linux-headers-$(uname -r) \
           curl \
           wget \
           vim \
           git \
           unzip \
           screen \
           htop \
           iotop \
           facter \
           jq
           
# Create user julius
username="julius"
useradd --home /home/${username} --create-home --groups sudo --shell /bin/bash ${username}

# Setup sudo for our user
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

# Disable DNS lookup for SSH connections (causes 10s delay if not deactivated)
echo "UseDNS no" >> /etc/ssh/sshd_config

###############################################################################
# Setup Google Cloud SDK
###############################################################################
export CLOUD_SDK_REPO=cloud-sdk-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk

###############################################################################
# Setup AWS CLI
###############################################################################

sudo pip install awscli

