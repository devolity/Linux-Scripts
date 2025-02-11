#!/bin/bash

service opendkim stop; rm -rf /etc/opendkim*; rm -rf /etc/init.d/opendkim*; rm -rf /var/run/opendkim/*; rm -rf /usr/local/src/opendkim-2.4.2*
sed -i '/milter*/d' /etc/postfix/main.cf
sed -i '/maximal_queue_lifetime = 0/d' /etc/postfix/main.cf
sed -i '/initial_destination_concurrency = 10/d' /etc/postfix/main.cf
sed -i '/default_destination_concurrency_limit = 50/d' /etc/postfix/main.cf
service postfix restart

########Policyd remove
find / -type f -name "remi-*.rpm" -exec rm -f {} \;
find / -type f -name "epel-release-*.rpm" -exec rm -f {} \;
find / -type f -name "cluebringer-*.rpm" -exec rm -f {} \;
rm -rf /root/rpmbuild/RPMS/noarch/cluebringer-*
rm -rf /root/cluebringer-*

rpm -e cluebringer-*
rm -rf /var/log/cbpolicyd*
rm -rf /var/run/cbpolicyd*

sed -i 's/smtpd_recipient_restrictions.*/smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination/' /etc/postfix/main.cf
sed -i '/smtpd_end_of_data_restrictions*/d' /etc/postfix/main.cf

##############

