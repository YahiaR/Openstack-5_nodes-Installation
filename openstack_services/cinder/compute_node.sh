#!/bin/sh
sed -i 's/# filter = \[ "r|\/dev\/cdrom|" \].*/filter = \[ "a\/sda\/", "r\/.*\/"\]/g' /etc/lvm/lvm.conf