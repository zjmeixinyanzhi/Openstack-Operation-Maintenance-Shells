#!/bin/sh
vip='192.168.2.201'
vip=$virtual_ip

echo $vip
for i in 01 02 03 ;
do 
  ssh controller$i  /bin/bash << EOF
 
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/glance/glance-api.conf DEFAULT registry_host $vip
openstack-config --set /etc/glance/glance-registry.conf database connection mysql+pymysql://glance:$password@$vip/glance
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/glance/glance-registry.conf DEFAULT registry_host $vip
openstack-config --set /etc/glance/glance-api.conf DEFAULT bind_host $(ip addr show dev $local_nic scope global | grep "inet " | sed -e 's#.*inet ##g' -e 's#/.*##g'|head -n 1)
openstack-config --set /etc/glance/glance-registry.conf DEFAULT bind_host $(ip addr show dev $local_nic scope global | grep "inet " | sed -e 's#.*inet ##g' -e 's#/.*##g'|head -n 1)

EOF

done
