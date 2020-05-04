#!/bin/sh
parted /dev/sda resizepart 1 10000MB
fdisk /dev/sda
apt-get -y install xfsprogs rsync
mkfs.xfs /dev/sda2
mkfs.xfs /dev/sda3
mkdir -p /srv/node/sda2
mkdir -p /srv/node/sda3
printf "\n/dev/sda2 /srv/node/sda2 xfs noatime,nodiratime,nobarrier,logbufs=8 0 2" >> /etc/fstab
printf "\n/dev/sda3 /srv/node/sda3 xfs noatime,nodiratime,nobarrier,logbufs=8 0 2" >> /etc/fstab
mount /srv/node/sda2
mount /srv/node/sda3