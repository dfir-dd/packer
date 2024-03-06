#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# install Dissect
if [ ! -x /usr/local/bin/acquire ] ; then
    python3 -m pip install dissect acquire dissect.fve      
fi