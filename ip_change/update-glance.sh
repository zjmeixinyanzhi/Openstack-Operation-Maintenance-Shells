#!/bin/sh
nodes_name=(${!controller_mapnew[@]});
vip=$virtual_ip

for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/glance/glance-api.conf database connection mysql+pymysql://glance:$password@$vip/glance
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/glance/glance-api.conf DEFAULT registry_host $vip
openstack-config --set /etc/glance/glance-registry.conf database connection mysql+pymysql://glance:$password@$vip/glance
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/glance/glance-registry.conf DEFAULT registry_host $vip
openstack-config --set /etc/glance/glance-api.conf DEFAULT bind_host $ip
openstack-config --set /etc/glance/glance-registry.conf DEFAULT bind_host $ip
EOF
 
  done
