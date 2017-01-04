#!/bin/sh
nodes_name=(${!controller_mapnew[@]});

for ((i=0; i<${#controller_mapnew[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${controller_mapnew[$name]};
      echo "-------------$name : $ip ------------"
      scp /etc/haproxy/haproxy.cfg root@${ip}:/etc/haproxy/
  done;
