#!/bin/bash

# Only run for vmware
if [[ `facter virtual` != "vmware" ]]; then
  exit 0
fi

mkdir -p /mnt/vmware
mount -o loop /home/vagrant/linux.iso /mnt/vmware

cd /tmp
tar xzf /mnt/vmware/VMWareTools-*.tar.gz

ummount /mnt/vmwware
rm -fr /home/vagrant/linux.iso

/tmp/vmware-tools-distrib/vmware-install.pl -d
rm -fr /tmp/vmware-tools-distrib

