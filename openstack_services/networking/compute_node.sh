#!/bin/sh
apt-get -y install neutron-linuxbridge-agent
sed -i 's/connection = sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite.*/#connection = sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite/g' /etc/neutron/neutron.conf
sed -i 's/^\[DEFAULT\]$/\[DEFAULT\]\ntransport_url = rabbit:\/\/openstack:RABBIT_PASS@controller\n/' /etc/neutron/neutron.conf
sed -i 's/#auth_strategy =.*/auth_strategy = keystone/g' /etc/neutron/neutron.conf
sed -i 's/#auth_uri =.*/auth_uri = http:\/\/controller:5000/g' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nauth_url = http:\/\/controller:5000/' /etc/neutron/neutron.conf
sed -i 's/#memcached_servers =.*/memcached_servers = controller:11211/g' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nauth_type = password/' /etc/neutron/neutron.conf        
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nproject_domain_name = default/' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nuser_domain_name = default/' /etc/neutron/neutron.conf  
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nproject_name = service/' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\nusername = neutron/' /etc/neutron/neutron.conf
sed -i 's/^\[keystone_authtoken\]$/\[keystone_authtoken\]\npassword = NEUTRON_PASS/' /etc/neutron/neutron.conf     
sed -i 's/#lock_path = \/tmp.*/lock_path = \/var\/lib\/neutron\/tmp/g' /etc/neutron/neutron.conf
sed -i 's/#physical_interface_mappings =.*/physical_interface_mappings = provider:enp0s9/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#enable_vxlan = true.*/enable_vxlan = true/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#local_ip = <None>.*/local_ip = 20.0.2.31/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#l2_population = false.*/l2_population = true/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#enable_security_group = true.*/enable_security_group = true/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#firewall_driver = <None>.*/firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sed -i 's/#url = http:\/\/127.0.0.1:9696.*/url = http:\/\/controller:9696/g' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nauth_url = http:\/\/controller:5000\n/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nauth_type = password\n/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nproject_domain_name = default\n/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nuser_domain_name = default\n/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nregion_name = RegionOne\n/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nproject_name = service\n/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\nusername = neutron\n/' /etc/nova/nova.conf
sed -i 's/^\[neutron\]$/\[neutron\]\npassword = NEUTRON_PASS\n/' /etc/nova/nova.conf
service nova-compute restart
service neutron-linuxbridge-agent restart