#!/bin/bash
###############

sudo apt -y update
sudo apt -y upgrade
sudo apt -y install wget tar curl unzip sendmail libwww-perl liblwp-protocol-https-perl libgd-graph-perl

sudo cd /usr/src
sudo rm -fv csf.tgz
sudo wget https://download.configserver.com/csf.tgz
sudo tar -xzf csf.tgz
sudo cd csf
sudo sh install.sh

## #test csf
sudo perl /usr/local/csf/bin/csftest.pl

#configure CSF
sudo sed -i 's/TESTING = "1"/TESTING = "0"/g' /etc/csf/csf.conf
sudo sed -i 's/RESTRICT_SYSLOG = "0"/RESTRICT_SYSLOG = "1"/g' /etc/csf/csf.conf
sudo sed -i 's/CT_LIMIT = "0"/CT_LIMIT = "50"/g' /etc/csf/csf.conf
sudo sed -i 's/CT_PERMANENT = "0"/CT_PERMANENT = "1"/g' /etc/csf/csf.conf
sudo sed -i 's/CT_BLOCK_TIME = "1800"/CT_BLOCK_TIME = "600"/g' /etc/csf/csf.conf
sudo sed -i 's/CONNLIMIT = ""/CONNLIMIT ="22;15"/g' /etc/csf/csf.conf

sudo systemctl stop sendmail
sudo csf -r
