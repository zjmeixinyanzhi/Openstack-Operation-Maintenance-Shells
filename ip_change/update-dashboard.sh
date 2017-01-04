#!/bin/sh
nodes_name=(${!controller_mapnew[@]});
vip=$virtual_ip

for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
       ssh $ip /bin/bash << EOF
sed -i \
    -e 's#OPENSTACK_HOST =.*#OPENSTACK_HOST = "'"${vip}"'"#g' \
    -e 's#^OPENSTACK_KEYSTONE_URL =.*#OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST#g' \
    /etc/openstack-dashboard/local_settings
sed -i -e 's/^Listen.*/Listen  '"${ip}"':80/g' /etc/httpd/conf/httpd.conf
EOF
 
  done
