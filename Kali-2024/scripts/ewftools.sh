#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# install Tools for E01 mounting
if [ ! -x /usr/bin/ewfmount ] ; then
    apt-get install -yq libewf-dev ewf-tools
fi