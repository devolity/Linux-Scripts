#!/bin/bash

# Remote Server IP
rserver=127.0.0.1

# Define Manual SSH port
sshport=22

# Define Server Password
shpassrd=5es

# Remote backup location
remotback=/home/Raw-Backup/

# Local backup location
localback=/mnt/Remote-Data/$rserver

#
mkdir -p $localback

# rsync command with non-standard port
rsync -ar --exclude xxx $remotback $localback

########
