#!/bin/sh
apt-get -y install etcd
sed -i "s/# ETCD_NAME=.*/ETCD_NAME=\"controller\"/g" /etc/default/etcd
sed -i "s/# ETCD_DATA_DIR=.*/ETCD_DATA_DIR=\"\\/var\\/lib\\/etcd\"/g" /etc/default/etcd
sed -i "s/# ETCD_INITIAL_CLUSTER_STATE=.*/ETCD_INITIAL_CLUSTER_STATE=\"new\"/g" /etc/default/etcd
sed -i "s/# ETCD_INITIAL_CLUSTER_TOKEN=.*/ETCD_INITIAL_CLUSTER_TOKEN=\"etcd-cluster-01\"/g" /etc/default/etcd      
sed -i "s/# ETCD_INITIAL_CLUSTER=.*/ETCD_INITIAL_CLUSTER=\"controller=http:\\/\\/20.0.2.11:2380\"/g" /etc/default/etcd
sed -i "s/# ETCD_INITIAL_ADVERTISE_PEER_URLS=.*/ETCD_INITIAL_ADVERTISE_PEER_URLS=\"http:\\/\\/20.0.2.11:2380\"/g" /etc/default/etcd
sed -i "s/# ETCD_ADVERTISE_CLIENT_URLS=.*/ETCD_ADVERTISE_CLIENT_URLS=\"http:\\/\\/20.0.2.11:2379\"/g" /etc/default/etcd
sed -i "s/# ETCD_LISTEN_PEER_URLS=.*/ETCD_LISTEN_PEER_URLS=\"http:\\/\\/0.0.0.0:2380\"/g" /etc/default/etcd        
sed -i "s/# ETCD_LISTEN_CLIENT_URLS=.*/ETCD_LISTEN_CLIENT_URLS=\"http:\\/\\/20.0.2.11:2379\"/g" /etc/default/etcd  
systemctl enable etcd
systemctl restart etcd