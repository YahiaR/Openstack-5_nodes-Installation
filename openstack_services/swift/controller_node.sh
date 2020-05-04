#!/bin/sh
. /vagrant_data/admin-openrc.sh
openstack user create --domain default --password SWIFT_PASS swift
openstack role add --project service --user swift admin
openstack service create --name swift --description "OpenStack Object Storage" object-store
openstack endpoint create --region RegionOne object-store public http://controller:8080/v1/AUTH_%\(project_id\)s
openstack endpoint create --region RegionOne object-store internal http://controller:8080/v1/AUTH_%\(project_id\)s
openstack endpoint create --region RegionOne object-store admin http://controller:8080/v1
apt-get -y install swift swift-proxy python-swiftclient python-keystoneclient python-keystonemiddleware memcached
sudo mkdir /etc/swift
sudo curl -o /etc/swift/proxy-server.conf https://opendev.org/openstack/swift/raw/branch/master/etc/proxy-server.conf-sample
sed -i 's/# user = swift.*/user = swift/g' /etc/swift/proxy-server.conf
sed -i 's/# swift_dir = \/etc\/swift.*/swift_dir = \/etc\/swift/g' /etc/swift/proxy-server.conf
sed -i 's/pipeline = catch_errors gatekeeper healthcheck proxy-logging cache listing_formats container_sync bulk tempurl ratelimit tempauth copy container-quotas account-quotas slo dlo versioned_writes symlink proxy-logging proxy-server.*/pipeline = catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server/g' /etc/swift/proxy-server.conf
sed -i 's/# account_autocreate = false.*/account_autocreate = True/g' /etc/swift/proxy-server.conf
sed -i 's/# \[filter:keystoneauth\].*/\[filter:keystoneauth\]/g' /etc/swift/proxy-server.conf
sed -i 's/# use = egg:swift#keystoneauth.*/use = egg:swift#keystoneauth/g' /etc/swift/proxy-server.conf
sed -i 's/# operator_roles = admin, swiftoperator.*/operator_roles = admin,user/g' /etc/swift/proxy-server.conf
sed -i 's/# \[filter:authtoken\].*/\[filter:authtoken\]/g' /etc/swift/proxy-server.conf
sed -i 's/# paste.filter_factory = keystonemiddleware.auth_token:filter_factory.*/paste.filter_factory = keystonemiddleware.auth_token:filter_factory/g' /etc/swift/proxy-server.conf
sed -i 's/# www_authenticate_uri = http:\/\/keystonehost:5000.*/www_authenticate_uri = http:\/\/controller:5000/g' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\nauth_url = http:\/\/controller:5000\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\nmemcached_servers = controller:11211\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\nauth_type = password\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\nproject_domain_id = default\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\nuser_domain_id = default\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\nproject_name = service\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\nusername = swift\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\npassword = SWIFT_PASS\n/' /etc/swift/proxy-server.conf
sed -i 's/^\[filter:authtoken\]$/\[filter:authtoken\]\ndelay_auth_decision = True\n/' /etc/swift/proxy-server.conf
sed -i 's/# memcache_servers = 127.0.0.1:11211.*/memcache_servers = controller:11211/g' /etc/swift/proxy-server.conf



