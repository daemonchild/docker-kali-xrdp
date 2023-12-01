#!/bin/bash
#
# Project: Relates to Terraform of CTF environment
# Author:  Daemonchild
# Purpose: Build Kali Container, with XRDP, for CTFs
#
echo [Kali Linux Container - XRDP Enabled - Daemonchild]
/usr/sbin/xrdp
/usr/sbin/xrdp-sesman
/opt/tomcat8/bin/startup.sh
/usr/local/sbin/guacd
/usr/games/cowsay Now point a browser at me!
sleep infinity