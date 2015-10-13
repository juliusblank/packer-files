#!/bin/bash

set -ex

###############################################################################
# Perform base installation                                                   #
###############################################################################

# TODO:
# * install JDK7
# * install Maven

export DEBIAN_FRONTEND=noninteractive

apt-get -y update

# install lpackage
# linux-image-extra-$(uname -r)- support for AUFS
# linux-image-extra-virtual
# linux-headers-$(uname -r)   
# facter                       - gather system information
# curl                         - tool to transfer a URL
# wget                         - The non-interactive network downloader
# jq                           - prettyprint / modify JSON
# vim                          - vi improved
# git                          - the stupid content tracker
# htop                         - interactive process viewer
# gcc                          - compiler - needed for guest additions
# make                          - build tool - needed for guest additions
# lxc-docker                   - docker
# cgroup-bin                   - cgroup support programs
# cgmanager-utils              - client script to simplify making requests of the cgroup manager
# iotop                        - simple top-like I/O monitor
# openssh-server               - well...
apt-get -y install \
           linux-image-extra-$(uname -r) \
           linux-image-extra-virtual\
           linux-headers-$(uname -r) \
           facter \
           build-essential \
           zlib1g-dev \
           libssl-dev \
           libreadline-gplv2-dev \
           curl \
           wget \
           jq \
           vim \
           git \
           htop \
           gcc \
           make \
           cgroup-bin \
           cgmanager-utils \
           iotop \
           openssh-server

# Disable DNS lookup for SSH connections (causes 10s delay if not deactivated)
echo "UseDNS no" >> /etc/ssh/sshd_config
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i -e 's/#AuthorizedKeysFile\s\%h\/.ssh\/authorized_keys/AuthorizedKeysFile\t\%h\/.ssh\/authorized_keys/g' /etc/ssh/sshd_config


# Adjust memory and swap accounting. Otherwise cgroups won't work properly.
cat <<EOF > /etc/default/grub
# If you change this file, run `update-grub` afterwards to update
# /boot/grub/grub.cfg

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb-release -i -s 2> /dev/null || echo debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
EOF

#sed -i '/GRUB_CMDLINE_LINUX=""/c\GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' /etc/default/grub
update-grub