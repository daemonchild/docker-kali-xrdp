#!/bin/bash

# Project:  Relates to Terraform of CTF environment
# Author:   Daemonchild
# Purpose:  Build Kali Container, with XRDP, for CTFs
# Note:     Build time: Approx 15-20 mins
#           Image size: 11.5GB
#           Adds User Config

# SSH Config
cat << EOF > /etc/ssh/sshd_config
Port 22
ListenAddress 0.0.0.0

SyslogFacility AUTH
LogLevel INFO

PermitRootLogin yes
StrictModes no
MaxSessions 10
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
KbdInteractiveAuthentication yes
UsePAM yes

AllowTcpForwarding yes
GatewayPorts no
X11Forwarding yes
PermitTTY yes
PrintMotd no
PrintLastLog no
TCPKeepAlive no

Banner none

AcceptEnv LANG LC_*
PubkeyAcceptedAlgorithms=+ssh-rsa
HostKeyAlgorithms +ssh-rsa
EOF

# Generate a local SSH key for each users
ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""

# Add 5 users user-a to user-e
for s in a b c d e; do
   username="user-${s}"
   echo $username
   useradd -m $username
   echo "$username:$username" | chpasswd
   touch /home/$username/.hushlogin 
   echo "$username ALL=(ALL) NOPASSWD:ALL" | EDITOR='tee -a' visudo
   usermod -a -G sudo $username
   chsh $username -s /bin/zsh
done

# User experience :)
touch /root/.hushlogin

# clear up
cat /dev/null > /root/.bash_history
cat /dev/null > /root/.zsh_history