#!/bin/sh
apt-get -y install chrony
echo "allow 20.0.2.0/24" | tee -a /etc/chrony/chrony.conf
service chrony restart
apt-get -y update && apt-get -y dist-upgrade
apt-get -y install python-openstackclient mariadb-server python-pymysql
cp /vagrant_data/99-openstack.cnf /etc/mysql/mariadb.conf.d/99-openstack.cnf
service mysql restart
mysqladmin password "database_password"
apt-get -y install rabbitmq-server
rabbitmqctl add_user openstack RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
apt-get -y install memcached python-memcache
sed -i 's/-l 127.0.0.1.*/-l 20.0.2.11/g' /etc/memcached.conf
service memcached restart