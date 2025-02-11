#!/usr/bin/bash
##########
# Devolity Enterprise
#   _____   .__     .______.            
#  /  _  \  |__|  __| _/\_ |__    ______
# /  /_\  \ |  | / __ |  | __ \  /  ___/
#/    |    \|  |/ /_/ |  | \_\ \ \___ \ 
#\____|__  /|__|\____ |  |___  //____  >
#        \/          \/      \/      \/ 
# www.devolity.com
#---#
wget https://www.dropbox.com/s/ennlkpaoi8a9k1q/User-ssh-key.sh && bash User-ssh-key.sh
#---#
echo " NOTE :- Before run this script please Sure SSH Key add User script was Successfully Run!! "
### Deploy Scripts Directory
BACKUP_USER=backup_admin
cron_user=$(whoami)

#---- Deploy Backups Directory
DATA_DIR=/home/.Raw2022s
LOG_DIR="${DATA_DIR}"/Logs-Record

#----
mkdir -p "${DATA_DIR}"
mkdir -p "${LOG_DIR}"
#----
touch "${LOG_DIR}"/mysqlbkup.log
touch "${LOG_DIR}"/mysqlbkup-err.log
#----
touch "${LOG_DIR}"/filebkup.log
touch "${LOG_DIR}"/filebkup-err.log

#---- Deploy the executable
cd "${DATA_DIR}"
wget https://www.dropbox.com/s/1vgqjtr8fk8xbkx/Backup-User-Aidbs-Cloud.sh
wget https://www.dropbox.com/s/x88iusxosoe9hvu/DB-Backup-All.sh
wget https://www.dropbox.com/s/3wiofrwlhj5w7kv/File-Dir-Backup.sh
wget https://www.dropbox.com/s/lma83qiym360h7m/.filebkup.conf
wget https://www.dropbox.com/s/xxc6ul7hh8lc3im/.mysqlbkup.cnf
wget https://www.dropbox.com/s/94f5j1hapoaj3qe/.mysqlbkup.config

#----
chmod 711 "${DATA_DIR}"/*.sh
#---- Deploy the configuration files
chmod 600 "${DATA_DIR}"/.mysqlbkup.config
chmod 600 "${DATA_DIR}"/.mysqlbkup.cnf
chmod 600 "${DATA_DIR}"/.filebkup.conf
chmod 700 "${DATA_DIR}"
chmod 700 "${LOG_DIR}"

#---- Inform the user about important manual steps
echo "All Backup Scripts is installed"

echo "
@@@@@@@
"
echo "Make sure to edit ${DATA_DIR}/.mysqlbkup.cnf and ${DATA_DIR}/.mysqlbkup.config for your needs"

echo "Your crontab is configured to backup script periodically"
echo "
@@@@@@@
"
echo "It's schedule the script to run once daily"

#---- Check cron Entry If already Present
#---- For Redhat / Centos
sed -i '/.Raw2022s/d' /var/spool/cron/${cron_user}

#---- For Ubuntu 20.X+
sed -i '/.Raw2022s/d' /var/spool/cron/crontabs/${cron_user}

### Entry of Cron in user file Redhat / Centos

echo "00 1 * * * /usr/bin/bash "${DATA_DIR}"/Backup-User-Aidbs-Cloud.sh" >> /var/spool/cron/${cron_user}

#---- Deleting Script
find / -type f -name "Install-User-Backup.sh" -exec rm -f {} \;
find / -type f -name "User-ssh-key.sh" -exec rm -f {} \;
#----
echo "

Your Backup System is Installed Successfully, Thanks For Using Us

"
#---# EOF

