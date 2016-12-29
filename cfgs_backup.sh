#!/bin/sh
dir=/var/lib/backups/configs/`hostname`-`eval date +%Y%m%d%H%M%S`-matika
echo $dir
mkdir -p $dir
for i in haproxy keystone glance nova neutron httpd cinder aodh ceilometer;
do
  cp -r /etc/$i/ $dir/
  echo "cp -r /etc/$i/ $dir/"
done
