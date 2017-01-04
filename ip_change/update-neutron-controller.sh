#!/bin/sh
nodes_name=(${!controller_mapnew[@]});
vip=$virtual_ip

for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/neutron/neutron.conf database connection mysql+pymysql://neutron:$password@$vip/neutron
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/neutron/neutron.conf nova auth_url http://$vip:35357
openstack-config --set /etc/nova/nova.conf neutron url http://$vip:9696
openstack-config --set /etc/nova/nova.conf neutron auth_url http://$vip:35357
openstack-config --set /etc/neutron/neutron.conf DEFAULT bind_host $ip 
egrep -v "^#|^$"  /etc/neutron/neutron.conf
EOF

  done

