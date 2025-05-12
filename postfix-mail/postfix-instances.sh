#!/bin/bash
clear
echo -e "o---------------------------------------------------o"
echo -e "|              :: Aidbs Technology ::               |"
echo -e "o---------------------------------------------------o"
echo -e "|             https://www.aidbs.com                 |"
echo -e "|                                                   |"
echo -e "|   Note :- This Script is tested on Centos 7.x     |"
echo -e "o---------------------------------------------------o"
echo -e "|         SMTP POSTFIX INSTANCE CONFIGURATION       |"
echo -e "o---------------------------------------------------o"
# SMTP Postfix Instance configuration

cat /etc/redhat-release
uname -i
postconf -d | grep 'mail_version ='
echo -e "Enter root user password"
read pass
echo -e "Enter Domain Name"
read domain
echo -e "Enter Main IP"
read main_ip
echo -e "Enter Main IP's Hostname"
read main_host
echo -e $main_ip 	$main_host >> /etc/hosts
echo -e "How many instances you want to make"
read inst
echo -e "\$TTL 2h;
@	IN	SOA $main_host hostmaster.$domain (
		1	;Serial
		10800	;Refresh after 3hours
		3600	;Retry after 1 hour
		604800;Expire after 1 week
		3600)	;Minimum TTL of 1 hour
@	 IN	 NS	 $main_host.
$main_host.	 IN	 A	 $main_ip" >> /var/named/$domain
postmulti -e init
sed -i "75i myhostname = $main_host" /etc/postfix/main.cf
sed -i "s/inet_interfaces = all/inet_interfaces = $main_host/" /etc/postfix/main.cf
sed -i "314i relayhost = $domain" /etc/postfix/main.cf
sed -i "s/smtpd_sasl_auth_enable = yes/smtp_sasl_auth_enable = yes/" /etc/postfix/main.cf
sed -i "s/smtpd_sasl_security_options = noanonymous/smtp_sasl_security_options = noanonymous/" /etc/postfix/main.cf
echo -e "alternative_config_directories = /etc/postfix-out
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
maximal_queue_lifetime = 0
initial_destination_concurrency = 10
default_destination_concurrency_limit = 50" >> /etc/postfix/main.cf
postmulti -I postfix-out -G mta -e create
for (( i=1;i<=$inst;i++ ))
{
echo -e "Enter "$i"st instance ip"
read inst_ip
echo -e "Enter "$i"st instance Hostname"
read inst_host
echo -e $inst_ip	$inst_host >> /etc/hosts
echo -e $inst_host 	root:$pass >> /etc/postfix/sasl_passwd
echo -e "@ 	IN	 MX	 0	 $inst_host." >> /var/named/$domain
echo -e "$inst_host.	 IN	 A	 $inst_ip" >> /var/named/$domain
if [ $i == 1 ]
then
sed -i "75i myhostname = $inst_host" /etc/postfix-out/main.cf
sed -i "s/master_service_disable = inet/#master_service_disable = inet/" /etc/postfix-out/main.cf
sed -i "s/authorized_submit_users = /authorized_submit_users = root/" /etc/postfix-out/main.cf
sed -i "s/inet_interfaces = localhost/inet_interfaces = $inst_host/" /etc/postfix-out/main.cf
sed -i "253i mynetworks_style = host" /etc/postfix-out/main.cf
echo -e "sender_based_routing = yes
smtp_bind_address = $inst_ip
alternative_config_directories = /etc/postfix
multi_instance_enable = yes
smtpd_sasl_auth_enable = yes
broken_sasl_auth_clients = yes
smtpd_sasl_security_options = noanonymous
smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination" >> /etc/postfix-out/main.cf
else
postmulti -I postfix-out`expr $i - 1` -G mta -e create
sed -i "75i myhostname = $inst_host" /etc/postfix-out`expr $i - 1`/main.cf
sed -i "s/inet_interfaces = localhost/inet_interfaces = $inst_host/" /etc/postfix-out`expr $i - 1`/main.cf
sed -i "253i mynetworks_style = host" /etc/postfix-out`expr $i - 1`/main.cf
sed -i "s/master_service_disable = inet/#master_service_disable = inet/" /etc/postfix-out`expr $i - 1`/main.cf
sed -i "s/authorized_submit_users = /authorized_submit_users = root/" /etc/postfix-out`expr $i - 1`/main.cf
echo -e "sender_based_routing = yes
smtp_bind_address = $inst_ip
alternative_config_directories = /etc/postfix
multi_instance_enable = yes
smtpd_sasl_auth_enable = yes
broken_sasl_auth_clients = yes
smtpd_sasl_security_options = noanonymous
smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination" >> /etc/postfix-out`expr $i - 1`/main.cf
fi
}
echo -e "zone \"$domain\" IN {
		type master;
		file \"$domain\";
};" >> /etc/named.conf
chgrp named /var/named/$domain
sed -i "/HOSTNAME/d" /etc/sysconfig/network
echo -e "HOSTNAME=\"$main_host\"" >> /etc/sysconfig/network
postmap /etc/postfix/sasl_passwd
service network restart
service named restart
service postfix restart
############################
rm -f instances.sh
