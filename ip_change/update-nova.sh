#!/bin/sh
nodes_name=(${!controller_mapnew[@]});
vip=$virtual_ip

for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/nova/nova.conf api_database connection mysql+pymysql://nova:$password@$vip/nova_api
openstack-config --set /etc/nova/nova.conf database connection mysql+pymysql://nova:$password@$vip/nova
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/nova/nova.conf glance api_servers http://$vip:9292
openstack-config --set /etc/nova/nova.conf DEFAULT my_ip $ip
openstack-config --set /etc/nova/nova.conf vnc vncserver_listen $ip
openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address $ip
openstack-config --set /etc/nova/nova.conf vnc novncproxy_host $ip
openstack-config --set /etc/nova/nova.conf DEFAULT osapi_compute_listen $ip
openstack-config --set /etc/nova/nova.conf DEFAULT metadata_listen $ip
openstack-config --set /etc/nova/nova.conf neutron url http://$vip:9696
openstack-config --set /etc/nova/nova.conf neutron auth_url http://$vip:35357
EOF
 
  done
