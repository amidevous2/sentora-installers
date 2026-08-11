#!/bin/bash
# postinstall script for ovh plateform ovh.com soyoustart.com and kimsufi.com
if command -v curl >/dev/null 2>&1; then
  curl -fL -o "/root/sentora_install.sh" "http://sentora.org/install"
elif command -v wget >/dev/null 2>&1; then
  wget "http://sentora.org/install" -O "/root/sentora_install.sh"
fi
chmod +x /root/sentora_install.sh
if [ -f /etc/centos-release ]; then
yum -y update
yum -y remove bind
yum clean all
elif [ -f /etc/lsb-release ]; then
apt-get update
apt-get -y dist-upgrade
apt-get clean
apt-get autoclean
fi
/root/sentora_install.sh -t Europe/Paris -d $(hostname --fqdn) -i public
echo "OK"
exit
