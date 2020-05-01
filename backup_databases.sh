#!/bin/bash

now=$(date +"%Y-%m-%d")
destination=/backup/$now
user=root
pass="$MYSQL_ROOT_PWD"

EMAILSUBJECT="[servername]: BACKUP DATABASES"
EMAILTO="mail@address"
EMAILMESSAGE="/tmp/emailmessage_backup_dbs.txt"

echo Starting backup MySQL Databases at $(date +"%T, %Y-%m-%d")... >$EMAILMESSAGE
date >>$EMAILMESSAGE

mkdir -p $destination

echo "The following databases are saved:" >>$EMAILMESSAGE

dblist=`mysqlshow -u$user -p$pass | awk '/\|/ {if ($2!="Databases") print $2}'`

cd $destination

for i in $dblist
do
   echo dumping DB $i >>$EMAILMESSAGE
   mysqldump -c -u$user -p$pass $i > $i.$now.sql
   tar -czf $i.$now.tar.gz $i.$now.sql
   rm $i.$now.sql
   tar -rf $now.databases.tar $i.$now.tar.gz
   rm $i.$now.tar.gz
   echo $i >>$EMAILMESSAGE
done
echo Backup MySQL Databases done. $(date +"%T") >>$EMAILMESSAGE

/usr/bin/mail -s "$EMAILSUBJECT" "$EMAILTO" < $EMAILMESSAGE
