#!/bin/bash

DOCKER_VERSION="1.8.2-0~trusty"
DOCKER_COMPOSE_VERSION="1.4.0"
###############################################################################
# Install docker                                                              #
###############################################################################
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list

apt-get -y update

apt-get -y install docker-engine=${DOCKER_VERSION}

###############################################################################
# Install docker compose                                                      #
###############################################################################
curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# With bash completion
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose --version | awk 'NR==1{print $NF}')/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

###############################################################################
# Perform docker configuration and user setup                                 #
###############################################################################

# allow user czm to user docker without sudo
usermod -aG docker vagrant

# Setup the docker daemon
cat <<EOF >/tmp/docker
# Docker Upstart and SysVinit configuration file

# Customize location of Docker binary (especially for development testing).
#DOCKER="/usr/local/bin/docker"

# If you need Docker to use an HTTP proxy, it can also be specified here.
#export http_proxy=""
#export https_proxy=""

# This is also a handy place to tweak where Docker's temporary files go.
#export TMPDIR="/mnt/bigdrive/docker-tmp"
DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock -r=true ${DOCKER_OPTS}"

EOF
mv /tmp/docker /etc/default/docker
