#!/bin/bash

###############################################################################
# TODO Setup packer for validating templates                                  #
# TODO Setup iptables                                                         #
# TODO Keys?                                                                  #
# TODO Update this script according to the new 15.04 script from work         #
# TODO Setup azure-cli (container with systemd-unit (systemd-docker)          #
# TODO Setup mesosphere dcos                                                  #
# TODO Setup AWS cli                                                          #
# TODO                                                                        #
###############################################################################

set -e

###############################################################################
# Setup the proxy for the build                                               #
###############################################################################

if [ -n "$build_proxy" ]; then
  export http_proxy=${build_proxy}
  export https_proxy=${build_proxy}
  echo "Acquire::http::proxy \"${build_proxy}\";" >> /etc/apt/apt.conf.d/70debconf
fi

###############################################################################
# Perform base installation                                                   #
###############################################################################

export DEBIAN_FRONTEND=noninteractive

# Install required packages
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

apt-get update
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
           lxc-docker \
           iotop
           
# Create user julius
username="julius"
useradd --home /home/${username} --create-home --groups sudo --shell /bin/bash ${username}

# Setup sudo for our user
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

# Disable DNS lookup for SSH connections (causes 10s delay if not deactivated)
echo "UseDNS no" >> /etc/ssh/sshd_config

###############################################################################
# Perform docker configuration and user setup                                 #
###############################################################################

# allow user julius to user docker without sudo
usermod -aG docker ${username}

# Setup the docker daemon
cat <<EOF >/tmp/docker
# Docker Upstart and SysVinit configuration file

# Customize location of Docker binary (especially for development testing).
#DOCKER="/usr/local/bin/docker"

# If you need Docker to use an HTTP proxy, it can also be specified here.
export http_proxy="${run_proxy}"
export https_proxy="${run_proxy}"

# This is also a handy place to tweak where Docker's temporary files go.
#export TMPDIR="/mnt/bigdrive/docker-tmp"
DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock -r=true ${DOCKER_OPTS}"

EOF
mv /tmp/docker /etc/default/docker


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
