#!/bin/bash
clear
echo -e "o---------------------------------------------------o"
echo -e "|              :: Devolity Enterprise ::               |"
echo -e "o---------------------------------------------------o"
echo -e "|             https://www.devolity.com                 |"
echo -e "|                                                   |"
echo -e "|   Note :- This Script is tested on Centos 7.x     |"
echo -e "o---------------------------------------------------o"
echo -e "|             DKIM KEY CONFIGURATIONS               |"
echo -e "o---------------------------------------------------o"
# SMTP DKIM KEY add and configuration (Add DKIM Key)
# echo -e "\x1b[32m"
# read -rsp $'          Press ENTER to continue...\n' -n1 key
# echo -e "\x1b[0m"

########################
echo -e 'nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4' > /etc/resolv.conf
chattr +i /etc/resolv.conf
########################
# echo -e "\x1b[32m" ### For Custome Domain Name
# read -p "Enter The HostName = " hn
# echo -e "\x1b[0m"
hn=`hostname -f` # Take HostName 
ip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'` # Take IP Address

sed -i "s/$ip.*/$ip  $hn/g" /etc/hosts

sed -i "s/HOSTNAME=.*/HOSTNAME=$hn/g" /etc/sysconfig/network

hostname "$hn"
# read -p "Enter The Selecter = " sl
sl=`shuf -i 2000-65000 -n 1` # Random Number 

#DKIM CONFIG
#####################################
un=`hostname -s`
dn=`hostname -d`

yum install wget -y
yum install perl -y
cd /usr/local/src
wget http://sourceforge.net/projects/opendkim/files/Previous%20Releases/opendkim-2.4.2.tar.gz

yum install sendmail-devel openssl-devel -y
yum install gcc -y
yum install make -y
tar zxvf opendkim-2.4.2.tar.gz
cd opendkim-2.4.2
./configure --sysconfdir=/etc --prefix=/usr/local --localstatedir=/var
make
make install
adduser opendkim
groupadd opendkim
groupadd mail
opendkim -s /sbin/nologin
mkdir  /var/run/opendkim
useradd -G mail opendkim
usermod -c "OpenDKIM" opendkim
chown opendkim:opendkim /var/run/opendkim
chmod 700 /var/run/opendkim
mkdir -p /etc/opendkim/keys
chown -R opendkim:opendkim /etc/opendkim
chmod -R go-wrx /etc/opendkim/keys
cp /usr/local/src/opendkim-2.4.2/contrib/init/redhat/opendkim /etc/init.d/
chmod 755 /etc/init.d/opendkim

mkdir /etc/opendkim/keys/$dn
/usr/local/bin/opendkim-genkey -D /etc/opendkim/keys/$dn/ -d /$dn -s $sl
chown -R opendkim:opendkim /etc/opendkim/keys/$dn
mv /etc/opendkim/keys/$dn/$sl.private /etc/opendkim/keys/$dn/$sl

sed -i 's/r=postmaster;/ /' /etc/opendkim/keys/$dn/$sl.txt

echo -e " AutoRestart    Yes
AutoRestartRate         10/1h
Canonicalization        relaxed/simple
ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyTable                refile:/etc/opendkim/KeyTable
LogWhy                  Yes
Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
SignatureAlgorithm      rsa-sha256
SigningTable            refile:/etc/opendkim/SigningTable
Socket                  inet:8891\@localhost
Syslog                  Yes
SyslogSuccess           Yes
TemporaryDirectory      /var/tmp
UMask                   022
UserID                  opendkim:opendkim " > /etc/opendkim.conf

#####CREATE FILE /etc/opendkim/KeyTable#######
touch /etc/opendkim/KeyTable
echo -e "$sl._domainkey.$dn $dn:$sl:/etc/opendkim/keys/$dn/$sl" > /etc/opendkim/KeyTable

#CREATE FILE  /etc/opendkim/SigningTable
touch /etc/opendkim/SigningTable
echo -e "* $sl._domainkey.$dn" > /etc/opendkim/SigningTable

#CREATE FILE /etc/opendkim/TrustedHosts
touch /etc/opendkim/TrustedHosts
echo -e " 127.0.0.1
$hn" >  /etc/opendkim/TrustedHosts 
#ADD Lines In Postfix/main.cf
echo -e 'smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters = $smtpd_milters
milter_default_action = accept
milter_protocol = 2' >> /etc/postfix/main.cf

hash -r
service opendkim restart
service postfix restart
chkconfig --level 2345 opendkim on
dk=`cat /etc/opendkim/keys/$dn/$sl.txt`
echo -e "\x1b[32m"
echo -e "
###############################

DKIM KEY :-

$dk
###############################"
##
cd /root
rm -rf install.sh dkim.sh master-server.sh
##
echo -e "\x1b[0m"
