#!/bin/sh
apt-get -y install openstack-dashboard
sed -i 's/OPENSTACK_HOST =.*/OPENSTACK_HOST = "controller"/g' /etc/openstack-dashboard/local_settings.py
echo "SESSION_ENGINE = 'django.contrib.sessions.backends.cache'" | sudo tee -a /etc/openstack-dashboard/local_settings.py
echo "OPENSTACK_API_VERSIONS = { \
    \"identity\": 3, \
    \"image\": 2, \
    \"volume\": 2, \
}" | sudo tee -a /etc/openstack-dashboard/local_settings.py
sed -i 's/'127.0.0.1:11211'.*/'controller:11211\','/g' /etc/openstack-dashboard/local_settings.py
sed -i 's/#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT =.*/OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True/g' /etc/openstack-dashboard/local_settings.py
sed -i 's/#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN =.*/OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"/g' /etc/openstack-dashboard/local_settings.py
sed -i 's/OPENSTACK_KEYSTONE_DEFAULT_ROLE =.*/OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"/g' /etc/openstack-dashboard/local_settings.py
sed -i 's/TIME_ZONE = "UTC".*/TIME_ZONE = "Europe\/Madrid"/g' /etc/openstack-dashboard/local_settings.py
# mirar la solucion de https://ask.openstack.org/en/question/108423/unable-to-log-into-horizon-in-ocata-previous-solution-doesnt-work/
sudo service apache2 reload