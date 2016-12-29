#!/bin/bash
backup_dir="/var/lib/backups/mysql"
mkdir -p $backup_dir
filename="${backup_dir}/mysql-`hostname`-`eval date +%Y%m%d%H%M%S`.sql.gz"
# Dump the entire MySQL database
/usr/bin/mysqldump  -uroot -pa263f6a89fa2 -h172.20.200.241 --opt --all-databases | gzip > $filename
# Delete backups older than 30 days
find $backup_dir/*.sql.gz -ctime +30 -type f -delete
