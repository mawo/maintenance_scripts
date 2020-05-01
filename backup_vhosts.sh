#!/bin/bash

now=$(date +"%Y-%m-%d")
mkdir -p /backup/$now
cd /var/www/vhosts

EMAILSUBJECT="[servername]: BACKUP VHOSTS"
EMAILTO="mail@address"
EMAILMESSAGE="/tmp/emailmessage_backup_vhosts.txt"
echo "The following files/folders are saved:"> $EMAILMESSAGE

# backup all folders in /hosting/vhosts (skip files/links)
for file in *; do
   if [ -d $file ]; then
    mkdir -p /backup/$now
    tar -czf /backup/$now/$file.$now.files.tar.gz $file
    tar -rf /backup/$now/$now.files.tar /backup/$now/$file.$now.files.tar.gz
    rm /backup/$now/$file.$now.files.tar.gz
    echo $file >>$EMAILMESSAGE
   fi
done

/usr/bin/mail -s "$EMAILSUBJECT" "$EMAILTO" < $EMAILMESSAGE
