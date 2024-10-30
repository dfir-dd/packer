#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

apt-get install -yq clang libssl-dev flex bison libscca-utils libscca-dev eza pipx

# switching to wayland
mkdir -p /etc/systemd/system/gdm.service.d
ln -sf /dev/null /etc/systemd/system/gdm.service.d/disable-wayland.conf
