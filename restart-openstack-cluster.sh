#!/bin/sh
. 0-set-config.sh

controller_name=(${!controller_map[@]});

mv /var/lib/mysql/gvwstate.dat /var/lib/mysql/gvwstate.dat.bak
galera_new_cluster

for ((i=0; i<${#controller_map[@]}; i+=1));
  do
	name=${controller_name[$i]};
        ip=${controller_map[$name]};
	if [ $name = "controller01"  ];then
          echo "controller01"
          ssh root@$ip systemctl restart rabbitmq-server
        else
          ssh root@$ip mv /var/lib/mysql/gvwstate.dat /var/lib/mysql/gvwstate.dat.bak
          ssh root@$ip systemctl restart mariadb
          ssh root@$ip systemctl restart rabbitmq-server 
        fi
  done;

ceph-rest-api -n client.admin > /dev/null 2>&1 &

ssh controller01 pcs cluster start --all
ssh network01 pcs cluster start --all
watch -n 0.5 pcs resource

rabbitmqctl cluster_status
mysql -uroot -p$password_galera_root -h $virtual_ip -e "SHOW STATUS LIKE 'wsrep_cluster_size';"

 . ~/keystonerc_admin
openstack compute service list
neutron agent-list
cinder service-list
