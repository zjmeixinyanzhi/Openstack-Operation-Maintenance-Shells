#!/bin/sh
nodes_name=(${!hypervisor_mapnew[@]});
vip=$virtual_ip

for ((i=0; i<${#hypervisor_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${hypervisor_mapnew[$name]};
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/nova/nova.conf vnc novncproxy_base_url http://$vip:6080/vnc_auto.html
openstack-config --set /etc/nova/nova.conf glance api_servers http://$vip:9292
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/nova/nova.conf neutron url http://$vip:9696
openstack-config --set /etc/nova/nova.conf neutron auth_url http://$vip:35357
openstack-config --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_uri http://$vip:5000
openstack-config --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_url http://$vip:35357
openstack-config --set /etc/ceilometer/ceilometer.conf service_credentials auth_url http://$vip:5000/v3
openstack-config --set /etc/nova/nova.conf DEFAULT my_ip $ip
openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address $ip
egrep -v "^#|^$"  /etc/nova/nova.conf
egrep -v "^#|^$"  /etc/neutron/neutron.conf
egrep -v "^#|^$"   /etc/ceilometer/ceilometer.conf
EOF
 
  done
