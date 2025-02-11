#!/bin/bash

/usr/bin/bash /mnt/.Raw-Script/bmh.sh
/usr/bin/bash /mnt/.Raw-Script/local.sh

# To delete files older than 5 days
find /mnt/Remote-Data/* -mtime +5 -delete

#############
emailbody=$(du -a -h /mnt/Remote-Data/* | sed "s/^/`date `/")
emailsub=$(hostname -f)

### Email Sending
curl -s --user 'api:3b1d3b5c0fe1400e53dbfae7ed1e3e10-a09d6718-ae8a1a2f' \
  https://api.mailgun.net/v3/sandbox4a4d99a138ed405abed4ed40fa325db3.mailgun.org/messages \
  -F from='Aidbs Backup Report <mailgun@sandbox4a4d99a138ed405abed4ed40fa325db3.mailgun.org>' \
  -F to=alert@devolity.com \
  -F subject="$emailsub -- Backups Report" \
  -F text="Today Backup Files Records == $emailbody"
###
####
