#!/bin/bash
 
echo "##############################################################
############## AWS Web Hosting Server Configuration ##############
##############       Created by devolity.com       ##############
##############       http://www.devolity.com       ############## 
##############################################################"
  
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
 
#####
yum update -y
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y epel-release
yum install -y wget httpd vsftpd mod_ssl httpd-tools mariadb-server mariadb php php-mysql php-gd php-devel php-mcrypt
 
#####
sed -i 's/^anonymous_enable=.*/#anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf
sed -i 's/^#chroot_local_user=YES/chroot_local_user=YES/g' /etc/vsftpd/vsftpd.conf
sed -i '/chroot_local_user=YES/a allow_writeable_chroot=YES' /etc/vsftpd/vsftpd.conf
 
#####
# grep "^[^#;]" /etc/vsftpd/vsftpd.conf
 
#####
useradd aidbsdata
mkdir -p /home/aidbsdata/aidbs_hosting
chmod -R 775 /home/aidbsdata/
 
#####
wget  https://www.dropbox.com/s/mwyorbb5ihxtmjv/index.html
mv index.html /home/aidbsdata/aidbs_hosting/
 
#####
sed -i 's|'/usr/share/httpd/noindex'|/home/aidbsdata/aidbs_hosting|g' /etc/httpd/conf.d/welcome.conf
sed -i 's|'/var/www/html'|/home/aidbsdata|g' /etc/httpd/conf/httpd.conf
 
#####
echo '<VirtualHost *:80>
 
     #  SSLEngine on
     #  SSLCertificateFile "/etc/ssl/aidbs.in.pem"
     #  SSLCertificateKeyFile "/etc/ssl/aidbs.in.key"
 
    ServerName invoice.aidbs.in
    ServerAlias invoice.aidbs.in
    DocumentRoot /home/aidbsdata/aidbs_hosting
 
    <Directory /home/aidbsdata/aidbs_hosting>
        Options FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
 
</VirtualHost>' >> /etc/httpd/conf/httpd.conf
 
#####
echo '<filesMatch ".(js|html|jpg|jpeg|png|svg|txt|css|php)$">
        SetOutputFilter DEFLATE
Header set Cache-Control "max-age=2592000, public"
</filesMatch>
DeflateCompressionLevel 7
DeflateMemLevel 8
DeflateWindowSize 10' > /etc/httpd/conf.d/mod_deflate.conf
 
#####
echo '<IfModule mod_expires.c>
ExpiresActive On
ExpiresByType image/jpg "access 1 month"
ExpiresByType image/jpeg "access 1 month"
ExpiresByType image/png "access 1 month"
ExpiresByType image/gif "access 1 month"
ExpiresByType image/svg "access 1 month"
ExpiresByType text/css "access 1 month"
ExpiresByType text/html "access 1 month"
ExpiresByType text/php "access 1 month"
ExpiresByType application/pdf "access 1 month"
ExpiresByType application/javascript "access 1 month"
ExpiresByType application/x-javascript "access 1 month"
ExpiresByType application/x-shockwave-flash "access 1 month"
ExpiresByType image/x-icon "access plus 1 year"
ExpiresDefault "access plus 2 days"
</IfModule>' > /etc/httpd/conf.d/mod_expires.conf
 
#####
systemctl start mariadb.service
/usr/bin/mysqladmin -u root password 'aidbs@2018'
#####
echo "CREATE USER 'aidbsdbu'@'localhost' IDENTIFIED BY 'WY3EM2Fz6SyMwfA8';" | mysql -u root -p'aidbs@2018'
##### Grant Privileges
echo "GRANT ALL PRIVILEGES ON *.* TO 'aidbsdbu'@'localhost' IDENTIFIED BY 'WY3EM2Fz6SyMwfA8';" | mysql -u root -p'aidbs@2018'
#####
echo "FLUSH PRIVILEGES;" | mysql -u root -p'aidbs@2018'
 
#####
systemctl enable httpd.service
systemctl enable vsftpd.service
systemctl enable mariadb.service
 
systemctl restart httpd.service
systemctl restart mariadb.service
systemctl restart vsftpd.service
 
#####
echo "################"

echo "*** Please Add aidbsdata User Password ***"
 
echo "*** Please Bind mysql to its Local Host ***"
 
##### END #####
