#!/bin/bash

#=====================================================#
#Enter the IP Address to check sender score of that IP#
#=====================================================#

read -p "Enter IP Address = " ip

#==============================#
#Now Reverse that particular IP#
#==============================#

rev_ip=`echo "$ip"|awk -F"." '{for(i=NF;i>0;i--) printf i!=1?$i".":"%s",$i}'`

output=`/usr/bin/nslookup "$rev_ip".score.senderscore.com`

add=`echo "$output" | grep "Address: 127.0.4"`

in=`echo "$output" | grep "NXDOMAIN"`

insuf=`echo "$in" | awk -F ":" '{print $2}'`


red='\e[0;31m'

NC='\e[0m' # No Color

if [ "$insuf" == " NXDOMAIN" ]

then
echo -e "$ip Sender Score is = ${red}INSUFFICIENT${NC}"

else

score=`echo "$add" | awk -F "." '{print "\033[1;32m" $4 "\033[0m"}'`
echo "$ip Sender Score is = $score"

fi

