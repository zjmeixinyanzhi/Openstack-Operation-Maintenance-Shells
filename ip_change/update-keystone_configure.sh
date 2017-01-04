#!/bin/sh
vip=$virtual_ip
password=$password
nodes_name=(${!controller_mapnew[@]});

for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
      oldip=${controller_map[$name]};
      echo $ip $oldip
       ssh $ip  /bin/bash << EOF
openstack-config --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:$password@$vip/keystone
sed -i -e 's#'"$oldip"'#'"$ip"'#g' /etc/httpd/conf.d/wsgi-keystone.conf 
EOF
 
  done
