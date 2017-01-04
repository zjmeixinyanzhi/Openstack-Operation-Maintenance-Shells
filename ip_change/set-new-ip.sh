#!/bin/sh
. 0-set-config.sh
. 0-set-config.sh.New 

nodes_name=(${!nodes_map[@]});

for ((i=0; i<${#nodes_map[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      old_ip=${nodes_map[$name]};
      new_ip=${nodes_mapnew[$name]};
      storge_ip=$(echo $store_network|cut -d "." -f1-3).$(echo $new_ip|awk -F "." '{print $4}')
      echo "-------------$name------------"
      #ssh root@$ip chmod -R  +x $target_sh
      ### set new ip
      if [ $old_ip = $new_ip  ];then
        echo "The two ips are same!"
      else
        echo "The two ips are different!"
	result=$(echo ${name} | grep "network")
	echo $result
	if [[ "$result" != "" ]]
	then
	    echo "True"
	    nic=$local_bridge
	else
	    echo "False"
	    nic=$local_nic
	fi
        ssh $storge_ip /bin/bash << EOF        
	sed -i -e '/^IPADDR/d' /etc/sysconfig/network-scripts/ifcfg-$nic	
	sed -i -e '/^GATEWAY/d' /etc/sysconfig/network-scripts/ifcfg-$nic	
	echo "GATEWAY="$new_gateway >> /etc/sysconfig/network-scripts/ifcfg-$nic
        echo "IPADDR="$new_ip >> /etc/sysconfig/network-scripts/ifcfg-$nic
        systemctl restart network 
EOF
      fi

  done;



