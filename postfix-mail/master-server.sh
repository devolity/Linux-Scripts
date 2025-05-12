#!/bin/bash
clear
echo -e "o---------------------------------------------------o"
echo -e "|              :: Aidbs Technology ::               |"
echo -e "o---------------------------------------------------o"
echo -e "|             https://www.aidbs.com                 |"
echo -e "|                                                   |"
echo -e "|   Note :- This Script is tested on Centos 7.x     |"
echo -e "o---------------------------------------------------o"
echo -e "|         SMTP MASTER SERVER CONFIGURATION          |"
echo -e "o---------------------------------------------------o"
# SMTP Master Server configuration (Add MTA Node)
echo -e "\x1b[32m"
read -rsp $'          Press ENTER to continue...\n' -n1 key
echo -e "\x1b[0m"

echo -e "\x1b[32m"
read -p "Enter HostName = " hns
echo -e "\x1b[0m"

echo -e "\x1b[32m"
read -p "Enter Number of Sub IPs = " sip
echo -e "\x1b[0m"
################
echo -e 'nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4' > /etc/resolv.conf
chattr +i /etc/resolv.conf
########################

ip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
# ip=`hostname -I  | awk '{print $1;}' | awk -F':' '{print $1;}'`

sed -i "s/$ip.*/$ip  $hns/g" /etc/hosts

sed -i "s/HOSTNAME=.*/HOSTNAME=$hns/g" /etc/sysconfig/network

hostname "$hns"

dn=`hostname -d`
####################DKIM Doptmz Remove
service opendkim stop; rm -rf /etc/opendkim*; rm -rf /etc/init.d/opendkim*; rm -rf /var/run/opendkim/*; rm -rf /usr/local/src/opendkim-2.4.2*
sed -i '/milter*/d' /etc/postfix/main.cf
sed -i '/maximal_queue_lifetime = 0/d' /etc/postfix/main.cf
sed -i '/initial_destination_concurrency = 10/d' /etc/postfix/main.cf
sed -i '/default_destination_concurrency_limit = 50/d' /etc/postfix/main.cf
########Policyd remove
find / -type f -name "remi-*.rpm" -exec rm -f {} \;
find / -type f -name "epel-release-*.rpm" -exec rm -f {} \;
find / -type f -name "cluebringer-*.rpm" -exec rm -f {} \;
rm -rf /root/rpmbuild/RPMS/noarch/cluebringer-*
rm -rf /root/cluebringer-*

rpm -e cluebringer-*
rm -rf /var/log/cbpolicyd*
rm -rf /var/run/cbpolicyd*

sed -i 's/smtpd_recipient_restrictions.*/smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination/' /etc/postfix/main.cf
sed -i '/smtpd_end_of_data_restrictions*/d' /etc/postfix/main.cf

wget https://www.dropbox.com/s/exv9uulqytgsjzz/awstats.mail.conf; mv -f awstats.mail.conf /etc/awstats/awstats.mail.conf

########################
sed  -i '/IGNORE*/d' /etc/postfix/header_checks
#######################
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

#################
echo -e "zone \""$dn"\"{
       type master;
       file \"/var/named/"$dn"\";
}; " >> /etc/named.conf
################
echo -e "\$TTL 86400
@       IN      SOA     $hns. hostmaster.$dn. (
                       2001062501 ; serial
                       21600      ; refresh after 6 hours
                       3600       ; retry after 1 hour
                       604800     ; expire after 1 week
                       86400 )    ; minimum TTL of 1 day
@                IN      NS      $hns.
$hns.    IN    A    $ip " >> /var/named/$dn

##################
declare -a array1
declare -a array2
declare -a array3

for ((i=1;i<=$sip;i++));

do
echo -e "\x1b[32m"
read -p "Enter $i Sub IP = " hip
echo -e "\x1b[0m"
array1+=("$hip");

echo -e "\x1b[32m"
read -p "Enter $i Sub HostName = " hnm
echo -e "\x1b[0m"
array2+=("$hnm");

echo -e "\x1b[32m"
read -p "Enter $i Sub IP Password = " Ips
echo -e "\x1b[0m"
array3+=("$Ips")
done

for ((j=0;j<$sip;j++));
do
echo "${array2[$j]}.    IN    A    ${array1[$j]}" >> /var/named/$dn
done

for ((k=0;k<$sip;k++));
do
echo "@   IN   MX   0   ${array2[$k]}." >> /var/named/$dn
done

for ((l=0;l<$sip;l++));
do
echo "${array2[$l]} root:${array3[$l]}" >> /etc/postfix/sasl_passwd
done

sed -i "75i myhostname = $hns" /etc/postfix/main.cf
sed -i "314i relayhost = $dn" /etc/postfix/main.cf
sed -i "s/smtpd_sasl_auth_enable = yes/smtp_sasl_auth_enable = yes/" /etc/postfix/main.cf
sed -i "s/smtpd_sasl_security_options = noanonymous/smtp_sasl_security_options = noanonymous/" /etc/postfix/main.cf
echo -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >>/etc/postfix/main.cf
postmap /etc/postfix/sasl_passwd

systemctl restart named 
systemctl restart crond
systemctl restart postfix

echo -e "\x1b[32m"
echo "Master is created sucessfully"
echo -e "\x1b[0m"
