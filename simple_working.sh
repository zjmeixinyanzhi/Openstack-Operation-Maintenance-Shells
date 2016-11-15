#!/bin/sh
while [ "1"="1"  ]
do
  echo ""
  echo "    Date:<->"` date "+%Y-%m-%d %H:%M:%S"`
  ping 192.168.32.1 -c 1
  sleep 1
done

