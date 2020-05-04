#!/bin/sh
. /vagrant_data/admin-openrc.sh
openstack compute service list
openstack catalog list
openstack image list