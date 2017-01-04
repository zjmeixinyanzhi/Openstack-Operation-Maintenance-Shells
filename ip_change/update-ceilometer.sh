#!/bin/sh
nodes_name=(${!controller_mapnew[@]});
vip=$virtual_ip
vip2=$virtual_ip_redis
for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/ceilometer/ceilometer.conf service_credentials auth_url http://$vip:5000/v3
openstack-config --set /etc/ceilometer/ceilometer.conf coordination backend_url 'redis://'"$vip2"':6379'
openstack-config --set /etc/ceilometer/ceilometer.conf api host $ip
egrep -v "^#|^$"  /etc/ceilometer/ceilometer.conf
EOF
 
  done
