#!/bin/bash
clear
echo -e "o---------------------------------------------------o"
echo -e "|               :: devolity MAIL ::                     |"
echo -e "o---------------------------------------------------o"
echo -e "|              http://www.devolity.com                  |"
echo -e "|                                                   |"
echo -e "|                                                   |"
echo -e "o---------------------------------------------------o"
echo -e "|CRON HEADER-CHECK DELIVERY AWSTATS RESOLVE HOSTNAME|"
echo -e "o---------------------------------------------------o"

echo -e "\x1b[32m"
read -rsp $'          Press ENTER to continue...\n' -n1 key
echo -e "\x1b[0m"

########################
echo -e 'nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4' > /etc/resolv.conf
chattr +i /etc/resolv.conf
########################
echo -e "\x1b[32m"
read -p "Enter The HostName = " hn
echo -e "\x1b[0m"

ip=`ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk '{print $2;}' | awk -F':' '{print $2;}'`

sed -i "s/$ip.*/$ip  $hn/g" /etc/hosts

sed -i "s/HOSTNAME=.*/HOSTNAME=$hn/g" /etc/sysconfig/network

hostname "$hn"
############
wget https://dl.dropboxusercontent.com/u/17801313/awstats.mail.conf; mv -f awstats.mail.conf /etc/awstats/awstats.mail.conf

########################
sed  -i '/IGNORE*/d' /etc/postfix/header_checks
#script for cron and body checks
########################
sed -i "s/#header_checks = /header_checks = /" /etc/postfix/main.cf
echo -e "#Sample For Dropping Headers:
/^Header: IfContains/          IGNORE
/^Received: from /             IGNORE
/^User-Agent:/                 IGNORE
/^X-Mailer:/                   IGNORE
/^X-Originating-IP:/           IGNORE" >> /etc/postfix/header_checks

###################### 

echo -e 'maximal_queue_lifetime = 0
initial_destination_concurrency = 10
default_destination_concurrency_limit = 50' >> /etc/postfix/main.cf

echo -e "@daily root rm -f /var/log/procmail.log-* /var/log/cron-* /var/log/maillog-* /var/log/messages-* /var/log/secure-* /var/log/spooler-* /var/log/btmp-*
@daily root rm -f /var/log/procmail.log.* /var/log/cron.* /var/log/maillog.* /var/log/messages.* /var/log/secure.* /var/log/spooler.* /var/log/btmp.*" >> /etc/crontab
######################
/etc/init.d/crond restart
/etc/init.d/postfix restart
#########################
rm -f crontab.sh
