#!/bin/bash
#
# Project: Relates to Terraform of CTF environment
# Author:  Daemonchild
# Purpose: Build Kali Container, with XRDP, for CTFs
#
echo [Kali Linux - XRDP Enabled]
echo [Listening on 3389/tcp]
/usr/sbin/xrdp
/usr/sbin/xrdp-sesman
/opt/tomcat8/bin/startup.sh
/usr/local/sbin/guacd
sleep infinity