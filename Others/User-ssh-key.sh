#!/bin/bash
###################
# Devolity Enterprise
# www.devolity.com
# info@devolity.com
###################
#----
BACKUP_USER=backup_admin
HOME_DIR=/home/Raw_Aidbs_com
#----
hname=`hostname -s`
ipaddr=`ip addr show $(ip route | awk '/default/ {print $5}') | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
keyname=`echo $hname-$ipaddr`

#----
useradd -m -d "${HOME_DIR}" -s /bin/bash "${BACKUP_USER}"
#---- Add user to Sudo
usermod -a -G sudo "${BACKUP_USER}"
#---- Add Password
# echo B6NVg9L%$CPa7%Q5 | passwd --stdin "${BACKUP_USER}"
#---- ensure the directory ir owned by the new user
mkdir -p "${HOME_DIR}"/.ssh

#---- Add Key
ssh-keygen -t rsa -b 4096 -C "help@devolity.com" -N "" -v -f "${HOME_DIR}"/.ssh/$keyname

#---- Move and Copy Public Key
mv "${HOME_DIR}"/.ssh/$keyname "${HOME_DIR}"/.ssh/$keyname.pem
cp "${HOME_DIR}"/.ssh/$keyname.pub "${HOME_DIR}"/.ssh/authorized_keys
chown -R "${BACKUP_USER}":"${BACKUP_USER}" "${HOME_DIR}"/.ssh

#---- make sure only the new user has permissions
chmod 700 "${HOME_DIR}"/.ssh
chmod 600 "${HOME_DIR}"/.ssh/authorized_keys

#-------- Changing Configuration on SSHD/Conf
#----sed -i 's/PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/^#----PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

#---- Upload Keys to Cloud
cd "${HOME_DIR}"/.ssh

curl -X POST https://content.dropboxapi.com/2/files/upload --header "Authorization: Bearer N-1uJICccaAAAAAAAAAAPRuQ0V_yne4zI_bFcwTiJ9G5oj3RXAfY9VqRdNRK9PpX" --header "Dropbox-API-Arg: {\"path\": \"/$keyname.pem\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" --header "Content-Type: application/octet-stream" --data-binary @$keyname.pem

curl -X POST https://content.dropboxapi.com/2/files/upload --header "Authorization: Bearer N-1uJICccaAAAAAAAAAAPRuQ0V_yne4zI_bFcwTiJ9G5oj3RXAfY9VqRdNRK9PpX" --header "Dropbox-API-Arg: {\"path\": \"/$keyname.pub\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" --header "Content-Type: application/octet-stream" --data-binary @$keyname.pub
cd ~
#----
rm -rf "${HOME_DIR}"/.ssh/*.p*
#----
systemctl restart sshd
#----Falllback
/etc/init.d/sshd restart
#----
printf "\033[1;32m Your Server is configure with Key based Authentication use '$keyname.pem' to Login \033[0m\n"
# EOF
