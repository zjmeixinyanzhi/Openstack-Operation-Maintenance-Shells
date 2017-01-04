#!/bin/sh
nodes_name=(${!nodes_mapnew[@]});

ssh-keygen
for ((i=0; i<${#nodes_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_mapnew[$name]};
      echo "-------------$name : $ip ------------"
      ssh-copy-id root@$ip
      #ssh-copy-id root@$name
      ssh-copy-id root@$(echo $store_network|cut -d "." -f1-3).$(echo $ip|awk -F "." '{print $4}')
  done;
