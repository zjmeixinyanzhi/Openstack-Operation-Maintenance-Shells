#!/bin/sh

nodes_name=(${!nodes_mapnew[@]});

tmp_file=/etc/hosts.bak
target=/etc/hosts
rm -rf  $tmp_file
### generate host file
for ((i=0; i<${#nodes_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_mapnew[$name]};
      echo "$ip $name">>$tmp_file
  done;
### scp to other nodes
for ((i=0; i<${#nodes_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_mapnew[$name]};
      echo "-------------$name------------"
      scp $tmp_file root@$ip:/etc/hosts
  done;
### check
for ((i=0; i<${#nodes_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_mapnew[$name]};
      echo "-------------$name------------"
      ###ping hostname
      ping -c 2 $name
      ssh root@$ip hostname
  done
### update hostname
echo "Please log in again and renew the local hostname!"
exit
