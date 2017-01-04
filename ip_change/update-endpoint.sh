#!/bin/sh
cat endpoint | while read line
do
    id=`echo "$line"|awk '{print $1}'`
    url=`echo "$line"|awk '{print $2}'`
    echo $id $url
    openstack endpoint set ${id} --url "${url}"
done
openstack endpoint list
