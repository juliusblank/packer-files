#!/bin/bash

date > /etc/vagrant_box_build_time

# Setup sudo for our vagrant user
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e '/Defaults\s\+env_reset/a Defaults\tenv_keep="SSH_AUTH_SOCK"' /etc/sudoers
sed -i -e '/Defaults\s\+env_reset/a Defaults:vagrant\t \!requiretty' /etc/sudoers
# evtl todo, weil nicht geklappt?
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

# setup keys for user vagrant
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# misc
echo "Development environment" > /etc/motd