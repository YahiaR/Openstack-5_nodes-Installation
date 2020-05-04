#!/bin/sh
mysql -u root -pdatabase_password -e "CREATE DATABASE keystone;"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';"
mysql -u root -pdatabase_password -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';"
apt-get -y install keystone apache2 libapache2-mod-wsgi
sed -i "s/connection = sqlite.*/connection = mysql+pymysql:\\/\\/keystone:KEYSTONE_DBPASS@controller\\/keystone/g" /etc/keystone/keystone.conf
sed -i "s/^\[token\]$/\[token\]\nprovider = fernet\n/g" /etc/keystone/keystone.conf
sudo su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password ADMIN_PASS --bootstrap-admin-url http://controller:5000/v3/ --bootstrap-internal-url http://controller:5000/v3/ --bootstrap-public-url http://controller:5000/v3/ --bootstrap-region-id RegionOne
echo "ServerName controller" | sudo tee -a /etc/apache2/apache2.conf
service apache2 restart