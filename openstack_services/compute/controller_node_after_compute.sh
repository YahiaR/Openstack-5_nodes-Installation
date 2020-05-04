#!/bin/sh
. /vagrant_data/admin-openrc.sh
openstack compute service list --service nova-compute
sudo su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova