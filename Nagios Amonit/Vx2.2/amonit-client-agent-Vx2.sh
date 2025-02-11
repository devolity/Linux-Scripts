#!/bin/bash

echo "##############################################################
##############   Server Monitoring V2.2 Client  ##############
##############       Created by devolity.com       ##############
##############       http://www.devolity.com       ##############                      
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
#########

sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
#####

read -p '** Enter Monitoring server IP Address : ' allowip
##### install Nrpe Client
yum install -y epel-release
yum -y install net-tools glibc glibc-common make gettext automake wget openssl-devel

#####
mkdir -p /tmp/amonit
cd /tmp/amonit

#wget https://www.dropbox.com/s/e422w4i25nkq8ge/linux-amonit-agent.tar.gz
#wget https://www.dropbox.com/s/y1gc024958wv9wp/nrpe.cfg
#wget https://www.dropbox.com/s/hdg9d2254nnmnte/check_mem
#wget https://www.dropbox.com/s/n25tzq1uc9jrlnk/check_mysql

#####
# tar xzf linux-amonit-agent.tar.gz
# cd linux-nrpe-agent
# echo y | ./fullinstall

##### Configuring Command
cd /tmp/amonit

echo y | cp nrpe.cfg /usr/local/nagios/etc/
echo y | cp check_mem /usr/local/nagios/libexec/
echo y | cp check_mysql /usr/local/nagios/libexec/

#####
firewall-cmd --zone=public --add-port=5666/tcp
firewall-cmd --zone=public --add-port=5666/tcp --permanent

##### Changing Permisions
chmod 775 /usr/local/nagios/libexec/*
chown root:nagios /usr/local/nagios/libexec/*

##### Allow Server IP
sed -i "s/only_from *.*/only_from = 127.0.0.1 localhost $allowip/g" /etc/xinetd.d/nrpe
######
systemctl restart xinetd

##### Remove All data
rm -rf /tmp/amonit

##### Amonit Client Verification  

echo "##############################################################
##############   Server Monitoring V2.2 Client  ##############
##############       Created by devolity.com       ##############
##############       https://www.devolity.com       ##############                      
##############################################################"

echo "##############  Checking Server Server Ports   ##############"
netstat -tunlp | grep 5666

echo -e "#### Nagios Client is configured Sucessfully ####";
echo -e "\e[1;32m ############ *END OF INSTALLATION* ############# \e[0m";
