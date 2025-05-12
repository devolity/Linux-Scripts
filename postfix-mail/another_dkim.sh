#!/bin/bash
clear
echo -e "o---------------------------------------------------o"
echo -e "|              :: Aidbs Technology ::               |"
echo -e "o---------------------------------------------------o"
echo -e "|             https://www.aidbs.com                 |"
echo -e "|                                                   |"
echo -e "|   Note :- This Script is tested on Centos 7.x     |"
echo -e "o---------------------------------------------------o"
echo -e "|          ANOTHER DKIM KEY CONFIGURATIONS          |"
echo -e "o---------------------------------------------------o"
# Another DKIM KEY add and configuration (Add DKIM Key)
echo -e "Please enter the domain name of Host server domainname:"
read domainname

echo -e "Please enter the Selector name of Host server selector:"
read selector

echo -e "Please enter the domain name through which you want to sign Domainname:"
read Domainname

mkdir /etc/opendkim/keys/$Domainname

chown -R opendkim:opendkim /etc/opendkim/keys/$Domainname

cp -rvf /etc/opendkim/keys/$domainname/$selector /etc/opendkim/keys/$Domainname/$selector
cp -rvf /etc/opendkim/keys/$domainname/$selector.txt /etc/opendkim/keys/$Domainname/$selector.txt

chown -R opendkim:opendkim /etc/opendkim/keys/$Domainname/$selector
chown -R opendkim:opendkim /etc/opendkim/keys/$Domainname/$selector.txt

echo "$selector._domainkey.$Domainname $Domainname:$selector:/etc/opendkim/keys/$Domainname/$selector" >> /etc/opendkim/KeyTable

echo "*@$Domainname $selector._domainkey.$Domainname" >> /etc/opendkim/SigningTable

service opendkim restart

postfix reload

cat /etc/opendkim/keys/$domainname/$selector.txt
rm -f another_dkim.sh
###############################################
