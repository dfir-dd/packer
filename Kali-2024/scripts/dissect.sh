#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# install Dissect
if [ ! -x /usr/local/bin/acquire ] ; then
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install dissect --include-deps   
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx inject dissect acquire --include-apps  
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx inject dissect dissect.fve  
fi