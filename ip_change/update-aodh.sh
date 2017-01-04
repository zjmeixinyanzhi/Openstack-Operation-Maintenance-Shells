#!/bin/sh
nodes_name=(${!controller_mapnew[@]});
vip=$virtual_ip
vip2=$virtual_ip_redis
for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/aodh/aodh.conf database connection mysql+pymysql://aodh:$password@$vip/aodh
openstack-config --set /etc/aodh/aodh.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/aodh/aodh.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/aodh/aodh.conf service_credentials auth_url http://$vip:5000/v3
openstack-config --set /etc/aodh/aodh.conf api host $ip
egrep -v "^#|^$" /etc/aodh/aodh.conf
EOF
 
  done
