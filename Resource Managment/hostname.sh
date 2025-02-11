#!/bin/bash
clear
echo -e "o---------------------------------------------------o"
echo -e "|               :: devolity MAIL ::                     |"
echo -e "o---------------------------------------------------o"
echo -e "|              http://www.devolity.com                  |"
echo -e "|                                                   |"
echo -e "|                                                   |"
echo -e "o---------------------------------------------------o"
echo -e "|           SMTP WITH APP CONFIGURATION             |"
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
###################

hostname
