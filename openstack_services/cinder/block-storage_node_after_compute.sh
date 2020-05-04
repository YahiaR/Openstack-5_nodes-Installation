#!/bin/sh
apt-get -y install cinder-volume
sudo rm /etc/cinder/cinder.conf
sudo cp /vagrant_data/openstack_services/cinder/cinder.conf /etc/cinder/cinder.conf
service tgt restart
service cinder-volume restart