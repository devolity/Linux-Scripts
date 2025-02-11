#!/bin/bash
clear
echo -e "o---------------------------------------------------o" 
echo -e "|                :: devolity MAIL ::                    |"
echo -e "o---------------------------------------------------o"
echo -e "|                http://www.devolity.com                |"
echo -e "|                                                   |"
echo -e "|                                                   |"
echo -e "o---------------------------------------------------o"
echo -e "|           SMTP WITHOUT APP CONFIGURATION          |"
echo -e "o---------------------------------------------------o"

echo -e "\x1b[32m"
read -rsp $'          Press ENTER to continue...\n' -n1 key
echo -e "\x1b[0m"

########################
echo -e 'nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4' >> /etc/resolv.conf
chattr +i /etc/resolv.conf
########################
echo -e "\x1b[32m"
read -p "Enter The HostName = " hn

read -p "Enter The Mysql password = " mp
 
read -p "Enter The Policy User Name = " pu
 
read -p "Enter The Mail Limits = " lm
echo -e "\x1b[0m"

ip=`ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk '{print $2;}' | awk -F':' '{print $2;}'`

sed -i "s/$ip.*/$ip  $hn/g" /etc/hosts

sed -i "s/HOSTNAME=.*/HOSTNAME=$hn/g" /etc/sysconfig/network

hostname "$hn"
#########################

wget https://dl.dropboxusercontent.com/u/17801313/awstats.mail.conf; mv -f awstats.mail.conf /etc/awstats/awstats.mail.conf
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

# Apply policy on server #
##########################
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
yum install perl-Net-Server mysql perl-Net-CIDR perl-Config-IniFiles perl-Cache-FastMmap perl-Mail-SPF perl-MIME-Lite php -y
wget devlabs.linuxassist.net/attachments/download/229/cluebringer-snapshot-2.1.x-201205100639.tar.bz2
tar -xvf cluebringer-snapshot-2.1.x-201205100639.tar.bz2
yum install rpm-build -y
rpmbuild -ta cluebringer-snapshot-2.1.x-201205100639.tar.bz2
rpm -ivh /root/rpmbuild/RPMS/noarch/cluebringer-2.1.x-201205100639.noarch.rpm
cd /root/cluebringer-snapshot-2.1.x-201205100639/database/
for i in core.tsql access_control.tsql quotas.tsql amavis.tsql checkhelo.tsql checkspf.tsql greylisting.tsql accounting.tsql; do ./convert-tsql mysql $i; done > policyd.sql
mysql -u root -p$mp -e 'create database policyd;' 
mysql -u root -p$mp policyd < /root/cluebringer-snapshot-2.1.x-201205100639/database/policyd.sql
sed -i 's/#Username=root/Username=root/' /etc/policyd/cluebringer.conf
sed -i "s/#Password=/Password=$mp/" /etc/policyd/cluebringer.conf;
mkdir /usr/local/lib/policyd-2.1
cp -r /root/cluebringer-snapshot-2.1.x-201205100639/cbp /usr/local/lib/policyd-2.1/
cp -r /root/cluebringer-snapshot-2.1.x-201205100639/awitpt/awitpt /usr/local/lib/policyd-2.1/
cp /root/cluebringer-snapshot-2.1.x-201205100639/cbpolicyd /usr/local/sbin/
cp /root/cluebringer-snapshot-2.1.x-201205100639/cbpadmin /usr/local/bin/
mkdir /var/log/cbpolicyd
mkdir /var/run/cbpolicyd
/etc/init.d/cbpolicyd start
sed -i 's/smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination/smtpd_recipient_restrictions = check_policy_service inet:127.0.0.1:10031 permit_mynetworks permit_sasl_authenticated reject_unauth_destination/' /etc/postfix/main.cf
echo 'smtpd_end_of_data_restrictions = check_policy_service inet:127.0.0.1:10031' >> /etc/postfix/main.cf

chkconfig --level 2345 cbpolicyd on

#Apply Rsyslog on Server #
###########################
yum install httpd php mysql php-mysql mysql-server rsyslog rsyslog-mysql -y
chkconfig --levels 35 rsyslog on
chkconfig --levels 35 mysqld on
chkconfig --levels 35 httpd on
sed -i  '1i $ModLoad ommysql.so' /etc/rsyslog.conf
service mysqld restart
sed -i  "2i *.* :ommysql:localhost,Syslog,rsyslog,$mp" /etc/rsyslog.conf
mysql -u root -p$mp -e 'CREATE USER "rsyslog"@"localhost" IDENTIFIED BY "$pass";'
mysql -u root -p$mp -e 'GRANT ALL PRIVILEGES ON Syslog.* TO "rsyslog"@"localhost" WITH GRANT OPTION;'
mysql -u root -p$mp < /usr/share/doc/rsyslog-mysql-5.8.10/createDB.sql
chkconfig rsyslog on
#DKIM CONFIG
#####################################
sed  -i '/milter*/d' /etc/postfix/main.cf

un=`hostname -s`
dn=`hostname -d`
sl=`shuf -i1234-12343 -n1`

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
service rsyslog restart
############################################
############
wd=`echo \$pu.sm | sed 's/^/$/'`
ss=$(cat /dev/urandom | tr -dc 'a-z0-9A-Z' | fold -w 9 | head -n 1) #Random User Password
######################
UserExist()
{
   awk -F":" '{ print $1 }' /etc/passwd | grep -x sm > /dev/null
   return $?
}
UserExist sm
if [ $? = 0 ]; then
 echo " "
else
virtualmin create-domain --domain sm.sm.com --pass $ss --desc "Dedicated User" --unix --dir --webmin --web --dns --mail --limits-from-plan
fi
######################
un=`echo \$pu.sm`
 
UserExist()
{
   awk -F":" '{ print $1 }' /etc/passwd | grep -x $un > /dev/null
   return $?
}
UserExist $un
if [ $? = 0 ]; then
echo -e "\x1b[31m"
   echo "$un <-- Already Exists."
echo -e "\x1b[0m"
 
else
###############
virtualmin create-user --domain sm.sm.com --user $pu --pass $ss --quota 150 --real "$pu.sm"
######################
mysql -D policyd -u root -p$mp << EOF
INSERT INTO policies (Name, Priority, Description, Disabled) VALUE ('$wd','100','SMTP User Policy', 0 );
INSERT INTO policy_members (PolicyID, Source, Destination, Comment, Disabled) VALUE ((SELECT id FROM policies WHERE name='$wd' LIMIT 1),'$wd', 'any', '$wd', 0);
INSERT INTO quotas (PolicyID, Name, Track, Period, Verdict, Data, LastQuota, Comment, Disabled) VALUE ((SELECT id FROM policies WHERE name='$wd' LIMIT 1),'$wd', 'SASLUsername', '3600', 'REJECT', 'You have reached your limit', 0, '$wd', 0);
INSERT INTO quotas_limits (QuotasID, Type, CounterLimit, Comment, Disabled) VALUE ((SELECT id FROM quotas WHERE PolicyID=(SELECT id FROM policies WHERE name='$wd' LIMIT 1) LIMIT 1), 'MessageCount' , '$lm', '$wd', 0);
EOF
fi
##########
dk=`cat /etc/opendkim/keys/$dn/$sl.txt`
############################################
echo -e "
############### COPY YOUR SMTP DETAIL FROM HERE #####################"
echo -e "\x1b[32m"
echo -e "
##############################

IP ADDRESS = $ip

HOSTNAME  = $hn

USERNAME  = $un

USER PASSWORD = $ss

PORT NO.  = 25
###############################

DKIM KEY :-

$dk

###############################"
echo -e "\x1b[0m"

echo -e "############ SMTP WITHOUT APP CONFIGURATION COMPLETED ####################"
