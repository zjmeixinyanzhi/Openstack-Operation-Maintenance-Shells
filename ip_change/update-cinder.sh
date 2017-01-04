#!/bin/sh
nodes_name=(${!controller_mapnew[@]});
vip=$virtual_ip

for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/cinder/cinder.conf database connection mysql+pymysql://cinder:$password@$vip/cinder
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/cinder/cinder.conf DEFAULT glance_api_servers http://$vip:9292
openstack-config --set /etc/cinder/cinder.conf DEFAULT osapi_volume_listen  $ip
openstack-config --set /etc/cinder/cinder.conf DEFAULT my_ip  $ip
egrep -v "^#|^$"  /etc/cinder/cinder.conf
EOF
 
  done
