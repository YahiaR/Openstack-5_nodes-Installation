#!/bin/sh
mysql -u root -pdatabase_password -e "CREATE DATABASE nova_api;"
mysql -u root -pdatabase_password -e "CREATE DATABASE nova;"
mysql -u root -pdatabase_password -e "CREATE DATABASE nova_cell0;"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';"   
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';"
. /vagrant_data/admin-openrc.sh
openstack user create --domain default --password NOVA_PASS nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
openstack user create --domain default --password PLACEMENT_PASS placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
apt-get -y install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api      
sed -i 's/connection = sqlite:\/\/\/\/var\/lib\/nova\/nova_api.sqlite.*/connection = mysql+pymysql:\/\/nova:NOVA_DBPASS@controller\/nova_api/g' /etc/nova/nova.conf
sed -i 's/connection = sqlite:\/\/\/\/var\/lib\/nova\/nova.sqlite.*/connection = mysql+pymysql:\/\/nova:NOVA_DBPASS@controller\/nova/g' /etc/nova/nova.conf
sed -i 's/^\[DEFAULT\]$/\[DEFAULT\]\ntransport_url = rabbit:\/\/openstack:RABBIT_PASS@controller\n/' /etc/nova/nova.conf
sed -i 's/#auth_strategy = keystone.*/auth_strategy = keystone/g' /etc/nova/nova.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nLINE1\nLINE2\nLINE3\nLINE4\nLINE5\nLINE6\nLINE7\nLINE8/' /etc/nova/nova.conf
sed -i 's/LINE1/auth_url = http:\/\/controller:5000\/v3/' /etc/nova/nova.conf
sed -i 's/LINE2/memcached_servers = controller:11211/' /etc/nova/nova.conf
sed -i 's/LINE3/auth_type = password/' /etc/nova/nova.conf
sed -i 's/LINE4/project_domain_name = default/' /etc/nova/nova.conf
sed -i 's/LINE5/user_domain_name = default/' /etc/nova/nova.conf
sed -i 's/LINE6/project_name = service/' /etc/nova/nova.conf
sed -i 's/LINE7/username = nova/' /etc/nova/nova.conf
sed -i 's/LINE8/password = NOVA_PASS/' /etc/nova/nova.conf
sed -i 's/#my_ip = <host_ipv4>.*/my_ip = 20.0.2.11/' /etc/nova/nova.conf
sed -i 's/#use_neutron = true.*/use_neutron = True/' /etc/nova/nova.conf
sed -i 's/#firewall_driver = nova.virt.firewall.NoopFirewallDriver.*/firewall_driver = nova.virt.firewall.NoopFirewallDriver/' /etc/nova/nova.conf
sed -i 's/^\[vnc\]$/\[vnc\]\nenabled = true\nserver_listen = $my_ip\nserver_proxyclient_address = $my_ip/' /etc/nova/nova.conf
sed -i 's/#api_servers = <None>.*/api_servers = http:\/\/controller:9292/g' /etc/nova/nova.conf
sed -i 's/#lock_path = \/tmp.*/lock_path = \/var\/lib\/nova\/tmp/g' /etc/nova/nova.conf
sed -i 's/^log_dir.*//' /etc/nova/nova.conf
sed -i 's/^os_region_name =.*//' /etc/nova/nova.conf
sed -i 's/^\[placement\]$/\[placement\]\nLINE1\nLINE2\nLINE3\nLINE4\nLINE5\nLINE6\nLINE7\nLINE8/' /etc/nova/nova.conf
sed -i 's/LINE1/os_region_name = RegionOne/' /etc/nova/nova.conf
sed -i 's/LINE2/project_domain_name = Default/' /etc/nova/nova.conf
sed -i 's/LINE3/project_name = service/' /etc/nova/nova.conf
sed -i 's/LINE4/auth_type = password/' /etc/nova/nova.conf
sed -i 's/LINE5/user_domain_name = default/' /etc/nova/nova.conf
sed -i 's/LINE6/auth_url = http:\/\/controller:5000\/v3/' /etc/nova/nova.conf
sed -i 's/LINE7/username = placement/' /etc/nova/nova.conf
sed -i 's/LINE8/password = PLACEMENT_PASS/' /etc/nova/nova.conf
sed -i 's/^\[scheduler\]$/\[scheduler\]\ndiscover_hosts_in_cells_interval = 300\n/' /etc/nova/nova.conf
sudo su -s /bin/sh -c "nova-manage api_db sync" nova
sudo su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
sudo su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
sudo su -s /bin/sh -c "nova-manage db sync" nova
nova-manage cell_v2 list_cells
service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart