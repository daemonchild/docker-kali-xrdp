#!/bin/bash

# Project:  Relates to Terraform of CTF environment
# Author:   Daemonchild
# Purpose:  Build Kali Container, with XRDP, for CTFs
# Note:     Build time: Approx 15-20 mins
#           Image size: 11.5GB

export SCRIPTDIR=/root/scripts
export USERLOCALE=en_GB.utf-8
export BCKPLOCALE=UTF-8

# Kali needs a language, or we end up with C.UTF-8.
apt update
apt install -y locales

echo en_GB.UTF-8 UTF-8 > /etc/locale.gen

locale-gen ${USERLOCALE}

# Generate preseed file
cat << EOF > ${SCRIPTDIR}/locales.txt
locales locales/locales_to_be_generated multiselect ${USERLOCALE} ${BCKPLOCALE}
locales locales/default_environment_locale select ${USERLOCALE}
EOF

# working above
debconf-set-selections ${SCRIPTDIR}/locales.txt

export LC_CTYPE=${USERLOCALE}
export LANG=${USERLOCALE}
export LANGUAGE=${USERLOCALE}
export LC_NUMERIC=${USERLOCALE}
export LC_TIME=${USERLOCALE}
export LC_COLLATE=${USERLOCALE}
export LC_MESSAGES=${USERLOCALE}
export LC_ALL=

# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf


# Install Kali Entire
echo "[Installing Full Kali]"
DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
DEBIAN_FRONTEND=noninteractive apt install -y kali-linux-default



