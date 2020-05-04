#!/bin/sh
mysql -u root -pdatabase_password -e "CREATE DATABASE cinder;"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'CINDER_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'CINDER_DBPASS';"
. /vagrant_data/admin-openrc.sh
openstack user create --domain default --password CINDER_PASS cinder
openstack role add --project service --user cinder admin
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3
openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s
apt-get -y install cinder-api cinder-scheduler
sudo rm /etc/cinder/cinder.conf
sudo cp /vagrant_data/openstack_services/cinder/cinder_controller.conf /etc/cinder/cinder.conf
su -s /bin/sh -c "cinder-manage db sync" cinder
sed -i 's/^#os_region_name.*//' /etc/nova/nova.conf
sed -i 's/^\[cinder\]$/\[cinder\]\nos_region_name = RegionOne\n/' /etc/nova/nova.conf
service nova-api restart
service cinder-scheduler restart
service apache2 restart
openstack volume service list