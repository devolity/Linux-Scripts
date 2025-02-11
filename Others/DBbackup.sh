#!/bin/bash

date=`date +"%Y-%m"`;
backupdir="/home/aidbsdata/$date";

### Server Setup ###
#* MySQL login Credentials *#
DBuser="aidbsdata";
DBpass="bRn#QD768=hAELs;";

# DO NOT BACKUP these databases
ignoredb="
information_schema
mysql
test
performance_schema
"
# Set default file permissions
 umask 002

#* MySQL binaries *#
MYSQL=`which mysql`;
MYSQLDUMP=`which mysqldump`;
#GZIP=`which gzip`;

# assuming that /nas is mounted via /etc/fstab
if [ ! -d $backupdir ]; then
  mkdir -p $backupdir
else
 :
fi

# get all database listing
DBS="$(mysql -u $DBuser -p$DBpass -Bse 'show databases')"

# SET DATE AND TIME FOR THE FILE
date=`date +"%a-%d-%m-%Y"`; # day-hour-minute-sec format

# start to dump database one by one
for db in $DBS
do
        DUMP="yes";
        if [ "$ignoredb" != "" ]; then
                for i in $ignoredb # Store all value of $ignoredb ON i
                do
                        if [ "$db" == "$i" ]; then # If result of $DBS(db) is equal to $ignoredb(i) then
                                DUMP="NO";         # SET value of DUMP to "no"
                                #echo "$i database is being ignored!";
                        fi
                done
        fi

        if [ "$DUMP" == "yes" ]; then # If value of DUMP is "yes" then backup database
                FILE="$backupdir/$date-$db.sql";
                # echo "BACKING UP $db";
                $MYSQLDUMP -u $DBuser -p$DBpass $db > $FILE
        fi
done

# Delete files older than 3 days
 find $backupdir/* -mtime +4 -exec rm -rf {} \;

# Change permission for Aidbs Access
chown -R aidbsdata:aidbsdata $backupdir/

##################################
