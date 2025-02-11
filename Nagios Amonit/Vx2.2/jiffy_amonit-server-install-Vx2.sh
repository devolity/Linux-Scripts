#!/bin/bash
echo "##############################################################
##############      Server Monitoring V2.2      ##############
##############       Created by devolity.com       ##############
##############       https://www.devolity.com       ##############                      
##############################################################"

echo "                                                                                                   ";
echo "                                                     dddddddd  bbbbbbbb                             ";
echo "               AAA                 iiii              d::::::d  b::::::b                             ";
echo "              A:::A               i::::i             d::::::d  b::::::b                            ";
echo "             A:::::A               iiii              d::::::d  b::::::b                            ";
echo "            A:::::::A                                 d:::::d  b:::::b                             ";
echo "           A:::::::::A           iiiiiii      ddddddddd:::::d  b:::::bbbbbbbbb        ssssssssss   ";
echo "          A:::::A:::::A          i:::::i    dd::::::::::::::d  b::::::::::::::bb    ss::::::::::s  ";
echo "         A:::::A A:::::A          i::::i   d::::::::::::::::d  b::::::::::::::::b  ss:::::::::::::s ";
echo "        A:::::A   A:::::A         i::::i  d:::::::ddddd:::::d  b:::::bbbbb:::::::b s::::::ssss:::::s";
echo "       A:::::A     A:::::A        i::::i  d::::::d    d:::::d  b:::::b    b::::::b s:::::s  ssssss ";
echo "      A:::::AAAAAAAAA:::::A       i::::i  d:::::d     d:::::d  b:::::b     b:::::b   s::::::s      ";
echo "     A:::::::::::::::::::::A      i::::i  d:::::d     d:::::d  b:::::b     b:::::b      s::::::s   ";
echo "    A:::::AAAAAAAAAAAAA:::::A     i::::i  d:::::d     d:::::d  b:::::b     b:::::b ssssss   s:::::s ";
echo "   A:::::A             A:::::A   i::::::i d::::::ddddd::::::d  b:::::bbbbbb::::::b s:::::ssss::::::s";
echo "  A:::::A               A:::::A  i::::::i d:::::::::::::::::d  b::::::::::::::::b  s::::::::::::::s ";
echo " A:::::A                 A:::::A i::::::i  d:::::::::ddd::::d  b:::::::::::::::b    s:::::::::::ss  ";
echo "AAAAAAA                   AAAAAAAiiiiiiii   ddddddddd   ddddd  bbbbbbbbbbbbbbbb      sssssssssss    ";
echo "                                                                                                    ";
echo "                                                                                                    ";
echo "                                                                               Devolity Enterprise     ";
echo "                                                                             https://www.devolity.com  ";
#######
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
######
echo -e "#################################";
echo -e "\e[1;32m checking Installation System..... \e[0m";

echo -e "\e[1;32m Verifying archive integity.... All good.... \e[0m";

echo -e "\e[1;32m Uncompressing Aidbs Monitring System Installer..... \e[0m";

echo "Your Server information...";
############
echo -e "#################################";
memory=$(grep 'MemTotal' /proc/meminfo |tr ' ' '\n' |grep [0-9])
arch=$(uname -i)
os=$(cut -f 1 -d ' ' /etc/redhat-release)
release=$(grep -o "[0-9]" /etc/redhat-release |head -n1)
ipadrs=`ifconfig | awk '$1 ~ /inet/ && $2 !~ /127.0.0|::1|fe80:/ {print $2}' |cut -d/ -f1 | head -1`
############

echo -e " - Total Memory \e[1;32m $memory \e[0m ";

echo -e " - Server Architecture $arch ";

echo -e " - Server OS $os ";

echo -e " - OS relese $release";

echo -e " - Server IP Address \e[1;32m $ipadrs \e[0m";

##### Installing Packages
echo -e "#################################";
yum install -y epel-release
yum install -y gcc net-tools glibc glibc-common make gettext automake wget openssl-devel net-snmp net-snmp-utils unzip httpd php gd gd-devel perl mariadb mariadb-server mariadb-devel
yum install -y perl-Net-SNMP mrtg net-snmp net-snmp-utils perl-Time-HiRes mysql perl-DBI perl-DBD-MySQL rrdtool perl-rrdtool perl-Time-HiRes php-gd

##### Complete Httpd Service
systemctl start httpd.service
systemctl start mariadb.service

##### Source Files Download # Modifing Configuration Files
mkdir -p /tmp/amonit
cd /tmp/amonit/

wget https://www.dropbox.com/s/4i55lfgaufun2nm/amonit-core.tar.gz
wget --no-check-certificate https://www.dropbox.com/s/tfaz81vp0st76kx/amonit-plugins.tar.gz
wget https://www.dropbox.com/s/63jisk1aluaw1g5/ndoutils.tar.gz
wget https://www.dropbox.com/s/94n7zqzo0opd5ma/jiffy_amonit_theme.zip
wget https://www.dropbox.com/s/rsiyr6b8taw3g6s/pnp4nagios-tar.gz
wget https://www.dropbox.com/s/e422w4i25nkq8ge/linux-amonit-agent.tar.gz

##### Download Configuration Scripts
wget https://www.dropbox.com/s/gi41xd49abgrxkg/check_printstat
wget https://www.dropbox.com/s/hdg9d2254nnmnte/check_mem
wget https://www.dropbox.com/s/n25tzq1uc9jrlnk/check_mysql
wget https://www.dropbox.com/s/hagsownpyiegi72/check_snmp

##### Conf Files
wget https://www.dropbox.com/s/rm34oy22pmn7an1/commands.cfg
wget https://www.dropbox.com/s/gpxlen9mmpq3ae2/linuxhost.cfg
wget https://www.dropbox.com/s/2b8oeh452npwtvn/templates.cfg
wget https://www.dropbox.com/s/gdsx6a2bjl29fhg/nagios.cfg
wget https://www.dropbox.com/s/e4snb3jlbf04dba/nrpe.cfg
wget https://www.dropbox.com/s/ejwigbcxujqcx6n/netowkswitch_allport.cfg
wget https://www.dropbox.com/s/mpxxfvhj1c9dzc3/netowkswitch.cfg
wget https://www.dropbox.com/s/ldur6st0yu3g08y/networkprinter.cfg
wget https://www.dropbox.com/s/jv2nx5wo8ax3eb4/networkrouter.cfg
wget https://www.dropbox.com/s/ei8yuwa1w2gkaou/windowshost.cfg
wget https://www.dropbox.com/s/qwsohp7l5msvmd5/index.html

##### Extract Sources
tar zxf amonit-plugins.tar.gz
tar xzf amonit-core.tar.gz
tar xzf linux-amonit-agent.tar.gz

###### Source compile
cd /tmp/amonit/nagioscore-nagios-4.3.4/
./configure
make all

##### Create user & group
useradd nagios
usermod -a -G nagios apache

##### Install Binaries
make install

##### Install Service daeoman
make install-init
systemctl enable nagios.service
systemctl enable httpd.service

##### Install Command-mode
make install-commandmode

##### install Config files
make install-config

##### Install Apache Config files
make install-webconf

##### Install plugins
cd /tmp/amonit/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install

##### Installing amonit agent for Linux
cd /tmp/amonit/linux-nrpe-agent/
echo y | ./fullinstall

##### Installing Theme Aidbs Monitoring
cd /tmp/amonit/
unzip -o jiffy_amonit_theme.zip -d /usr/local/nagios/share/

mkdir -p /var/www/mrtg
mkdir -p /usr/local/nagios/etc/linux-servers
mkdir -p /usr/local/nagios/etc/windows-servers
mkdir -p /usr/local/nagios/etc/network-switchs
mkdir -p /usr/local/nagios/etc/network-routers
mkdir -p /usr/local/nagios/etc/network-printers

##### Configuration of Snmp
echo "#########################################
###### sec.name   source          community (password)
com2sec Mybox     localhost          public
com2sec local     localhost          public
com2sec network   0.0.0.0            public
com2sec Outside   default            public
###### group.name sec.model  sec.name
group   RWGroup    v1       Mybox
group   RWGroup    v2c       Mybox
group   RWGroup    usm       Mybox
group   ROGroup    v1        network
group   ROGroup    v2c       network
group   ROGroup    usm       network
group   Others     v2c       Outside
#####
view all     included  .1        80
view system  included  system    fe
###### context sec.model sec.level prefix  read    write  notif
access  ROGroup         any    noauth    exact   all     none   none
access  RWGroup         v2c    noauth    exact   all     all    all
access  Others          v2c    noauth    exact   system  none   all
###### Details
syscontact INF <mail@devolity.com> "> /etc/snmp/snmpd.conf

systemctl restart snmpd

##### Coping Main Configurations
echo y | cp nagios.cfg /usr/local/nagios/etc/
echo y | cp commands.cfg /usr/local/nagios/etc/objects/
echo y | cp templates.cfg /usr/local/nagios/etc/objects/
echo y | cp nrpe.cfg /usr/local/nagios/etc/

##### Coping Plugins
echo y | cp check_printstat /usr/local/nagios/libexec/
echo y | cp check_snmp /usr/local/nagios/libexec/
echo y | cp check_mem /usr/local/nagios/libexec/
echo y | cp check_mysql /usr/local/nagios/libexec/

####### Copy Sample Conf files
echo y | cp linuxhost.cfg /usr/local/nagios/etc/linux-servers/
echo y | cp windowshost.cfg /usr/local/nagios/etc/windows-servers/
echo y | cp netowkswitch.cfg /usr/local/nagios/etc/network-switchs/
echo y | cp netowkswitch_allport.cfg /usr/local/nagios/etc/network-switchs/
echo y | cp networkrouter.cfg /usr/local/nagios/etc/network-routers/
echo y | cp networkprinter.cfg /usr/local/nagios/etc/network-printers/

####### Configure SNMP
cfgmaker --global 'WorkDir: /var/www/mrtg' --output /etc/mrtg/mrtg.cfg public@10.11.12.5

indexmaker --output=/var/www/mrtg/index.html /etc/mrtg/mrtg.cfg

echo "*/5 * * * * root LANG=C LC_ALL=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg --lock-file /var/lock/mrtg/mrtg_l --confcache-file /var/lib/mrtg/mrtg.ok
" >> /etc/crontab

###### Sample MRTG for routers

# cfgmaker --global 'WorkDir: /var/www/mrtg' --output /etc/mrtg/mrtg.cfg public@router

# cfgmaker --global 'WorkDir: /var/www/mrtg' --output /etc/mrtg/mrtg.cfg public@192.168.1.254

##### Configure NDOUTILS and MYsql  for Nagios

##### Mysql Access
/usr/bin/mysqladmin -u root password 'monitserver2018'

##### Extracting Source
cd /tmp/amonit/
tar xzf ndoutils.tar.gz
cd /tmp/amonit/ndoutils-2.1.3/
##### Configure All
./configure
##### Make All
make all
##### Make Install
make install
##### Install Services
make install-init

##### Create DB
echo 'CREATE DATABASE nagios DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;' | mysql -u root -p'monitserver2018' 
##### Create User
echo "CREATE USER 'ndoutils'@'localhost' IDENTIFIED BY 'ndou2018';" | mysql -u root -p'monitserver2018' 
##### Grant Permission
echo "GRANT USAGE ON *.* TO 'ndoutils'@'localhost' IDENTIFIED BY 'ndou2018' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ; " | mysql -u root -p'monitserver2018' 
##### Grant Privileges
echo "GRANT ALL PRIVILEGES ON nagios.* TO 'ndoutils'@'localhost' WITH GRANT OPTION ;" | mysql -u root -p'monitserver2018' 

##### Install DATABASE
cd db/
./installdb -u 'ndoutils' -p 'ndou2018' -h 'localhost' -d nagios

##### Install NDO Configuration
 cp /tmp/amonit/ndoutils-2.1.3/config/ndo2db.cfg-sample /usr/local/nagios/etc/ndo2db.cfg
 cp /tmp/amonit/ndoutils-2.1.3/config/ndomod.cfg-sample /usr/local/nagios/etc/ndomod.cfg
 
###### Add NDO UserName & Password
sed -i 's/^db_user=.*/db_user=ndoutils/g' /usr/local/nagios/etc/ndo2db.cfg
sed -i 's/^db_pass=.*/db_pass=ndou2018/g' /usr/local/nagios/etc/ndo2db.cfg

##### Backuping File
cp /etc/sysctl.conf /etc/sysctl.conf_backup

##### Modifing Kernel Parameter
printf "\n\nkernel.msgmnb = 131072000\n" >> /etc/sysctl.conf
printf "kernel.msgmax = 131072000\n" >> /etc/sysctl.conf
printf "kernel.shmmax = 4294967295\n" >> /etc/sysctl.conf
printf "kernel.shmall = 268435456\n" >> /etc/sysctl.conf

##### Module Add to nagios
#printf "\n\n# NDOUtils Broker Module\n" >> /usr/local/nagios/etc/nagios.cfg
#printf "broker_module=/usr/local/nagios/bin/ndomod.o config_file=/usr/local/nagios/etc/ndomod.cfg\n" >> /usr/local/nagios/etc/nagios.cfg 

##### Changing Permisions
chmod 775 /usr/local/nagios/libexec/*
chown root:nagios /usr/local/nagios/libexec/*

##### MRTG Apache Configuration
echo 'Alias /mrtg "/var/www/mrtg"

<Directory "/var/www/mrtg">
   Options None
   AllowOverride None
      <RequireAll>
         Require all granted
         AuthName "MRTG Access"
         AuthType Basic
         AuthUserFile /usr/local/nagios/etc/htpasswd.users
         Require valid-user
      </RequireAll>
        Order allow,deny
        Allow from all
        AuthName "MRTG Access"
        AuthType Basic
        AuthUserFile /usr/local/nagios/etc/htpasswd.users
        Require valid-user
</Directory>' > /etc/httpd/conf.d/mrtg.conf
#################
#### Default Web Page Redirect
mv /tmp/amonit/index.html /var/www/html/

##### Configure Pnp4Nagios Graph Tool 
cd /tmp/amonit/

tar xzf pnp4nagios-tar.gz
cd pnp4nagios-0.6.26
./configure
make all
make install
make install-webconf
make install-config
make install-init

##### Configure fireWall
firewall-cmd --zone=public --add-port=80/tcp
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=5666/tcp
firewall-cmd --zone=public --add-port=5666/tcp --permanent
firewall-cmd --zone=public --add-port=161/tcp
firewall-cmd --zone=public --add-port=162/tcp --permanent

#### Start Service
systemctl enable mariadb.service
systemctl enable ndo2db.service
systemctl enable httpd.service
systemctl enable xinetd
systemctl enable nagios
systemctl enable npcd 

systemctl restart mariadb.service
systemctl restart ndo2db.service
systemctl restart xinetd
systemctl daemon-reload
systemctl restart npcd.service
systemctl restart nagios.service
systemctl restart httpd.service

##### Create web login user account
echo -e "#################################";
echo -e "\e[1;32m Create your Web Login Password - \e[0m";

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

##### Remove All data
rm -f /usr/local/pnp4nagios/share/install.php
rm -rf /tmp/amonit

##### Amonit Server Verification  

echo -e "##############################################################
##############    Server Monitoring V2.2      ##############
##############    Installed Sucessfully       ##############
############## \e[1;32m Checking Server Configuration \e[0m ##############
##############################################################"
echo "############*Checking SNMP* ############"
snmpwalk -v 2c -c public localhost

echo "############ *Checking Amonit Configuration* ############"
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

echo "############ *Checking NDOUtils Logs* ############"
grep ndo /usr/local/nagios/var/nagios.log

echo "############ *Checking NDOUtils MYSQL Log Entries * ############"
echo 'select * from nagios.nagios_logentries;' | mysql -u ndoutils -p'ndou2018'

echo "############ *Checking Mysql DATABASE* ############"
echo 'show databases;' | mysql -u ndoutils -p'ndou2018' -h localhost

echo "############ *Checking Kernel entry* #############"
sysctl -e -p /etc/sysctl.conf

echo "############ *Checking Pnp4Nagios Data * #############"
ls -la /usr/local/pnp4nagios/var/perfdata/localhost/

echo "############ *Checking MariaDB Service* ############"
ps ax | grep mysql | grep -v grep

echo "############ *Checking Server Ports*############"
netstat -tunlp

echo -e "#################################";
echo -e "##### Monitoring Server is Successfully Installed #####";
echo -e "##### Web  Login to Server #####";
echo -e "URL/Domain Name = \e[1;32m  http://$ipadrs/nagios \e[0m";
echo -e "Username = \e[1;32m nagiosadmin \e[0m";
echo -e "Password = \e[1;32m Is given by you \e[0m";
echo -e "#################################";
echo -e "\e[1;32m ############ *END OF INSTALLATION* ############# \e[0m";
