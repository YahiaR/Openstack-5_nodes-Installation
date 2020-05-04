#!/bin/sh
apt-get -y install nova-compute
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
sed -i 's/#my_ip = <host_ipv4>.*/my_ip = 20.0.2.31/' /etc/nova/nova.conf
sed -i 's/#use_neutron = true.*/use_neutron = True/g' /etc/nova/nova.conf
sed -i 's/#firewall_driver = nova.virt.firewall.NoopFirewallDriver.*/firewall_driver = nova.virt.firewall.NoopFirewallDriver/g' /etc/nova/nova.conf
sed -i 's/^\[vnc\]$/\[vnc\]\nenabled = True\nserver_listen = 0.0.0.0\nserver_proxyclient_address = $my_ip\n/' /etc/nova/nova.conf
sed -i 's/#novncproxy_base_url = http:\/\/127.0.0.1:6080\/vnc_auto.html.*/novncproxy_base_url = http:\/\/controller:6080\/vnc_auto.html/g' /etc/nova/nova.conf
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
egrep -c '(vmx|svm)' /proc/cpuinfo >> /vagrant_data/virt_type.txt
sed -i 's/virt_type=kvm/virt_type = qemu/g' /etc/nova/nova-compute.conf

#variable= $(sudo egrep -c '(vmx|svm)' /proc/cpuinfo)
#if [[ "$variable" -ne 1 ]]; then
#  sed -i 's/#virt_type =.*/virt_type = qemu/g' /etc/nova/nova-compute.conf
#fi
service nova-compute restart