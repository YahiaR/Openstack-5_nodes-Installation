#!/bin/sh
apt-get -y install lvm2 thin-provisioning-tools
yes | sudo pvcreate /dev/sdb
yes | sudo vgcreate cinder-volumes /dev/sdb
sed -i 's/# filter = \[ "r|\/dev\/cdrom|" \].*/filter = \[ "a\/sda\/", "a\/sdb\/", "r\/.*\/"\]/g' /etc/lvm/lvm.conf