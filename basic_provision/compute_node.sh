#!/bin/sh
apt-get -y install chrony
sed -i 's/pool.*//g' /etc/chrony/chrony.conf
echo "server controller iburst" | tee -a /etc/chrony/chrony.conf
service chrony restart
apt-get -y update && apt-get -y dist-upgrade
apt-get -y install python-openstackclient