#!/bin/sh
mysql -u root -pdatabase_password -e "CREATE DATABASE glance;"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';"
. /vagrant_data/admin-openrc.sh
openstack user create --domain default --password GLANCE_PASS glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292
apt-get -y install glance
sed -i "s/connection = sqlite.*/connection = mysql+pymysql:\\/\\/glance:GLANCE_DBPASS@controller\\/glance/g" /etc/glance/glance-api.conf
sed -i "s/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nLINE1\nLINE2\nLINE3\nLINE4\nLINE5\nLINE6\nLINE7\nLINE8\nLINE9/" /etc/glance/glance-api.conf
sed -i "s/LINE1/auth_uri = http:\\/\\/controller:5000/" /etc/glance/glance-api.conf
sed -i "s/LINE2/auth_url = http:\\/\\/controller:5000/" /etc/glance/glance-api.conf
sed -i "s/LINE3/memcached_servers = controller:11211/" /etc/glance/glance-api.conf
sed -i "s/LINE4/auth_type = password/" /etc/glance/glance-api.conf
sed -i "s/LINE5/project_domain_name = Default/" /etc/glance/glance-api.conf
sed -i "s/LINE6/user_domain_name = Default/" /etc/glance/glance-api.conf
sed -i "s/LINE7/project_name = service/" /etc/glance/glance-api.conf
sed -i "s/LINE8/username = glance/" /etc/glance/glance-api.conf
sed -i "s/LINE9/password = GLANCE_PASS/" /etc/glance/glance-api.conf
sed -i "s/#flavor = keystone.*/flavor = keystone/" /etc/glance/glance-api.conf
sed -i "s/#stores = file.*/stores = file,http/" /etc/glance/glance-api.conf
sed -i "s/#default_store = file.*/default_store = file/" /etc/glance/glance-api.conf
sed -i "s/#filesystem_store_datadir = \\/var\\/lib\\/glance\\/images.*/filesystem_store_datadir = \\/var\\/lib\\/glance\\/images\\//" /etc/glance/glance-api.conf
sed -i "s/connection = sqlite.*/connection = mysql+pymysql:\\/\\/glance:GLANCE_DBPASS@controller\\/glance/" /etc/glance/glance-registry.conf
sed -i "s/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nLINE1\nLINE2\nLINE3\nLINE4\nLINE5\nLINE6\nLINE7\nLINE8\nLINE9/" /etc/glance/glance-registry.conf
sed -i "s/LINE1/auth_uri = http:\\/\\/controller:5000/" /etc/glance/glance-registry.conf
sed -i "s/LINE2/auth_url = http:\\/\\/controller:5000/" /etc/glance/glance-registry.conf
sed -i "s/LINE3/memcached_servers = controller:11211/" /etc/glance/glance-registry.conf
sed -i "s/LINE4/auth_type = password/" /etc/glance/glance-registry.conf
sed -i "s/LINE5/project_domain_name = Default/" /etc/glance/glance-registry.conf
sed -i "s/LINE6/user_domain_name = Default/" /etc/glance/glance-registry.conf
sed -i "s/LINE7/project_name = service/" /etc/glance/glance-registry.conf
sed -i "s/LINE8/username = glance/" /etc/glance/glance-registry.conf
sed -i "s/LINE9/password = GLANCE_PASS/" /etc/glance/glance-registry.conf
sed -i "s/#flavor = keystone.*/flavor = keystone/" /etc/glance/glance-registry.conf
sudo su -s /bin/sh -c "glance-manage db_sync" glance
sudo service glance-registry restart
sudo service glance-api restart

wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
. /vagrant_data/admin-openrc.sh
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public
openstack image list