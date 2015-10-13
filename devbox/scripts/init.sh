#!/bin/bash

set -ex

###############################################################################
# Setup the proxy for the build                                               #
###############################################################################

if [ -n "$build_proxy" ]; then
  echo "Using build proxy ${build_proxy}."
  export http_proxy=${build_proxy}
  export https_proxy=${build_proxy}
  echo "Acquire::http::proxy \"${build_proxy}\";" >> /etc/apt/apt.conf.d/70debconf
fi