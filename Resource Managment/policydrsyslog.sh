#!/bin/bash
#!/bin/bash
clear
echo -e "o---------------------------------------------------o"
echo -e "|               :: devolity MAIL ::                     |"
echo -e "o---------------------------------------------------o"
echo -e "|              http://www.devolity.com                  |"
echo -e "|                                                   |"
echo -e "|                                                   |"
echo -e "o---------------------------------------------------o"
echo -e "|              POLICY & RSYSLOG Apply               |"
echo -e "o---------------------------------------------------o"

echo -e "\x1b[32m"
read -rsp $'          Press ENTER to continue...\n' -n1 key
echo -e "\x1b[0m"

read -p "Please Enter root user password" pass

sed -i "1i nameserver 127.0.0.1" /etc/resolv.conf
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
mysql -u root -p$pass -e 'create database policyd;' 
mysql -u root -p$pass policyd < /root/cluebringer-snapshot-2.1.x-201205100639/database/policyd.sql
sed -i 's/#Username=root/Username=root/' /etc/policyd/cluebringer.conf
sed -i "s/#Password=/Password=$pass/" /etc/policyd/cluebringer.conf;
mkdir /usr/local/lib/policyd-2.1
cp -r /root/cluebringer-snapshot-2.1.x-201205100639/cbp /usr/local/lib/policyd-2.1/
cp -r /root/cluebringer-snapshot-2.1.x-201205100639/awitpt/awitpt /usr/local/lib/policyd-2.1/
cp /root/cluebringer-snapshot-2.1.x-201205100639/cbpolicyd /usr/local/sbin/
cp /root/cluebringer-snapshot-2.1.x-201205100639/cbpadmin /usr/local/bin/
mkdir /var/log/cbpolicyd
mkdir /var/run/cbpolicyd
sed -i 's/smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination/smtpd_recipient_restrictions = check_policy_service inet:127.0.0.1:10031 permit_mynetworks permit_sasl_authenticated reject_unauth_destination/' /etc/postfix/main.cf
echo 'smtpd_end_of_data_restrictions = check_policy_service inet:127.0.0.1:10031' >> /etc/postfix/main.cf

chkconfig --level 2345 cbpolicyd on
#####################################
yum install httpd php mysql php-mysql mysql-server wget rsyslog rsyslog-mysql -y
chkconfig --levels 35 rsyslog on
chkconfig --levels 35 mysqld on
chkconfig --levels 35 httpd on
sed -i  '1i $ModLoad ommysql.so' /etc/rsyslog.conf
service mysqld restart
sed -i  "2i *.* :ommysql:localhost,Syslog,rsyslog,$pass" /etc/rsyslog.conf
mysql -u root -p$pass -e 'CREATE USER "rsyslog"@"localhost" IDENTIFIED BY "$pass";'
mysql -u root -p$pass -e 'GRANT ALL PRIVILEGES ON Syslog.* TO "rsyslog"@"localhost" WITH GRANT OPTION;'
mysql -u root -p$pass < /usr/share/doc/rsyslog-mysql-5.8.10/createDB.sql

service postfix restart
/etc/init.d/cbpolicyd restart
service rsyslog restart
chkconfig rsyslog on
###########################
rm -f policyd.sh
