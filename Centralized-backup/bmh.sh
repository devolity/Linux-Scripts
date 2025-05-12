#!/bin/bash

# Remote Server IP
rserver=64.52.85.57

# Define Manual SSH port
sshport=22

# Define Server Password
shpassrd=5esamt294%

# Remote backup location
remotback=/home/Raw-Backup/

# Local backup location
localback=/mnt/Remote-Data/$rserver

#
mkdir -p $localback

# rsync command with non-standard port
rsync -avz -e "sshpass -p $shpassrd ssh -p $sshport -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress --exclude xxx $rserver:$remotback $localback

########
