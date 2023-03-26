#!/bin/bash
Date=`date +%Y-%m-%d`
Service=MY_DB
Directory=/backup/BackupSql/prod/$Service/$Date
#Date=`date +%Y-%d-%m`
Today=`date +%H-%M`
three_day=`date -d "3days ago" +'%F'`
Pass="xxxxxxxxxxxxx"
Expire=8

if [ ! -d $Directory ];
then
        mkdir -p /backup/BackupSql/$Service/$Date
fi
docker exec mysql mysqldump -h 192.168.111.10 -P 6037 -u root -p$Pass --quick --triggers --routines --lock-tables=false --single-transaction MY_DB > $Directory/$Service-$Today.sql
echo "dump is complete" >> /tmp/$Service.log
tar -czf $Directory/../$three_day/$Service-$Today.tar.gz $Directory/../$three_day/$Service-$Today.sql --remove-files
find $Directory/.. -type d -mtime +$Expire | xargs rm -rf
