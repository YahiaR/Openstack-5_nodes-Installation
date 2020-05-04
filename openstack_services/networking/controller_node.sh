#!/bin/sh
mysql -u root -pdatabase_password -e "CREATE DATABASE neutron;"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'NEUTRON_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'NEUTRON_DBPASS';"
. /vagrant_data/admin-openrc.sh
openstack user create --domain default --password NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696
apt-get -y install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent
sed -i 's/connection = sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite.*/connection = mysql+pymysql:\/\/neutron:NEUTRON_DBPASS@controller\/neutron/g' /etc/neutron/neutron.conf
sed -i 's/#service_plugins =.*/service_plugins = router/g' /etc/neutron/neutron.conf
sed -i 's/#allow_overlapping_ips = false.*/allow_overlapping_ips = true/g' /etc/neutron/neutron.conf
sed -i 's/^\[DEFAULT\]$/\[DEFAULT\]\ntransport_url = rabbit:\/\/openstack:RABBIT_PASS@controller\n/' /etc/neutron/neutron.conf
sed -i 's/#auth_strategy = keystone.*/auth_strategy = keystone/g' /etc/neutron/neutron.conf
sed -i 's/#auth_uri = <None>.*/auth_uri = http:\/\/controller:5000/g' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nauth_url = http:\/\/controller:5000/' /etc/neutron/neutron.conf
sed -i 's/#memcached_servers = <None>.*/memcached_servers = controller:11211/g' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nauth_type = password/' /etc/neutron/neutron.conf        
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nproject_domain_name = default/' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nuser_domain_name = default/' /etc/neutron/neutron.conf  
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nproject_name = service/' /etc/neutron/neutron.conf      
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nusername = neutron/' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\npassword = NEUTRON_PASS/' /etc/neutron/neutron.conf     
sed -i 's/#notify_nova_on_port_status_changes = true.*/notify_nova_on_port_status_changes = true/g' /etc/neutron/neutron.conf
sed -i 's/#notify_nova_on_port_data_changes = true.*/notify_nova_on_port_data_changes = true/g' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\nauth_url = http:\/\/controller:5000/' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\nauth_type = password/' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\nproject_domain_name = default/' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\nuser_domain_name = default/' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\nregion_name = RegionOne/' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\nproject_name = service/' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\nusername = nova/' /etc/neutron/neutron.conf
sed -i 's/^\[nova\]$/\[nova\]\npassword = NOVA_PASS/' /etc/neutron/neutron.conf
sed -i 's/#lock_path = \/tmp.*/lock_path = \/var\/lib\/neutron\/tmp/g' /etc/neutron/neutron.conf
sed -i 's/#type_drivers =.*/type_drivers = flat,vlan,vxlan/g' /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i 's/#tenant_network_types =.*/tenant_network_types = vxlan/g' /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i 's/#mechanism_drivers =.*/mechanism_drivers = linuxbridge,l2population/g' /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i 's/#extension_drivers =.*/extension_drivers = port_security/g' /etc/neutron/plugins/ml2/ml2_conf.ini        
sed -i 's/#flat_networks =.*/flat_networks = provider/g' /etc/neutron/plugins/ml2/ml2_conf.ini
sed -i 's/^\[ml2_type_vxlan\]$/\[ml2_type_vxlan\]\nvni_ranges = 1:1000/' /etc/neutron/plugins/ml2/ml2_conf.ini     
sed -i 's/#enable_ipset = true.*/enable_ipset = true/g' /etc/neutron/plugins/ml2/ml2_conf.ini
# pensar como conseguir el nombre a partir de ip r
sed -i 's/#physical_interface_mappings =.*/physical_interface_mappings = provider:enp0s9/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#enable_vxlan =.*/enable_vxlan = true/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#local_ip = <None>.*/local_ip = 20.0.2.11/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#l2_population =.*/l2_population = true/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#enable_security_group = true.*/enable_security_group = true/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#firewall_driver =.*/firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo sysctl net.bridge.bridge-nf-call-ip6tables=1
sed -i 's/#interface_driver =.*/interface_driver = linuxbridge/g' /etc/neutron/l3_agent.ini
sed -i 's/#interface_driver =.*/interface_driver = linuxbridge/g' /etc/neutron/dhcp_agent.ini
sed -i 's/#dhcp_driver =.*/dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq/g' /etc/neutron/dhcp_agent.ini
sed -i 's/#enable_isolated_metadata =.*/enable_isolated_metadata = true/g' /etc/neutron/dhcp_agent.ini
sed -i 's/#nova_metadata_host =.*/nova_metadata_host = controller/g' /etc/neutron/metadata_agent.ini
sed -i 's/#metadata_proxy_shared_secret =.*/metadata_proxy_shared_secret = METADATA_SECRET/g' /etc/neutron/metadata_agent.ini
sed -i 's/#url = http:\/\/127.0.0.1:9696.*/url = http:\/\/controller:9696/g' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nauth_url = http:\/\/controller:5000/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nauth_type = password/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nproject_domain_name = default/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nuser_domain_name = default/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nregion_name = RegionOne/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nproject_name = service/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nusername = neutron/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\npassword = NEUTRON_PASS/' /etc/nova/nova.conf
sed -i 's/#service_metadata_proxy =.*/service_metadata_proxy = true/g' /etc/nova/nova.conf
sed -i 's/#metadata_proxy_shared_secret =.*/metadata_proxy_shared_secret = METADATA_SECRET/g' /etc/nova/nova.conf 
sudo su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart