#!/bin/bash

# Project:  Relates to Terraform of CTF environment
# Author:   Daemonchild
# Purpose:  Build Kali Container, with XRDP, for CTFs
# Note:     Build time: Approx 15-20 mins
#           Image size: 11.5GB
#           Adds XRDP Layer

export SCRIPTDIR=/root/scripts
# Windows
echo "[Installing xfce and XRDP]"
DEBIAN_FRONTEND=noninteractive apt-get -y install kali-defaults kali-root-login desktop-base xfce4 xfce4-places-plugin xfce4-goodies libu2f-udev
DEBIAN_FRONTEND=noninteractive apt-get -y install xrdp dbus-x11

echo "port tcp://:3389" >> /etc/xrdp/xrdp.ini

mkdir -p /etc/polkit-1/localauthority/50-local.d/
cat << EOF > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

# install chrome, firefox, additional tools
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /root/google-chrome-stable_current_amd64.deb
DEBIAN_FRONTEND=noninteractive apt-get -y install fonts-liberation desktop-file-utils mailcap man-db libvulkan1
DEBIAN_FRONTEND=noninteractive dpkg -i /root/google-chrome-stable_current_amd64.deb
rm /root/google-chrome-stable_current_amd64.deb


