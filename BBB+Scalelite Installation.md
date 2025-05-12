# BBB+Scalelite Installation

**vc.imanage-school.com**

meeting.imanage-school.com - 147.135.255.191 -- (Scalelite+Redis+PostgreSQL)

turn.imanage-school.com - 51.210.104.93 -- Turn Server (VPS)

vc.imanage-school.com - 147.135.255.58 -- BBB-1 (Advnc2)

vc1.imanage-school.com - 51.210.214.155 -- BBB-2 (Infra-2)

vc2.imanage-school.com - 147.135.255.191 -- BBB-3 (Infra-2)

vc3.imanage-school.com - 51.178.78.130 -- BBB-3 (Advnc-3)

vc4.imanage-school.com - 54.36.61.190 -- BBB-3 (Advnc-3)

- ******************** **BBB** **Server Setup**

apt-get update && apt-get upgrade && apt-get dist-upgrade -y

apt-get install fail2ban

cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

fail2ban-client status

systemctl start fail2ban

systemctl enable fail2ban

- ********************** Install BBB and connect with Turn server**

wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v xenial-22 -s vc4.imanage-school.com -e info@vc.imanage-school.com -w -g

wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v xenial-22 -s vc4.imanage-school.com -e info@imanage-school.com -g -c turn.imanage-school.com:txg58QyT7LK2Pj

apt-get purge bbb-demo

---

- ********* Config Greenlight Frontend**
- -- change admin password for GreenLight

cd greenlight/

docker exec greenlight-v2 bundle exec rake admin:create

- -- after password change

admin@example.com -- nw4dsu!UiND$bc

---

*********** **Configured with Shared NFS Volumes**

```
# Create a new group with GID 2000
groupadd -g 2000 scalelite-spool
# Add the bigbluebutton user to the group
usermod -a -G scalelite-spool bigbluebutton

mkdir -p /mnt/scalelite-recordings

Copy Scalelite recording files to - below 
scalelite.yml, scalelite_post_publish.rb -- Files

cd /usr/local/bigbluebutton/core/scripts/ && wget https://www.dropbox.com/s/30wer2vps1yikvq/scalelite.yml && chmod +x scalelite.yml && ll

cd /usr/local/bigbluebutton/core/scripts/post_publish/ && wget https://www.dropbox.com/s/ttjjfad44ns6i6o/scalelite_post_publish.rb && chmod +x scalelite_post_publish.rb && ll

***** After that**

apt install nfs-common htop -y
df -h

mount meeting.imanage-school.com:/mnt/scalelite-recordings /mnt/scalelite-recordings

**Tunning** -

vi /usr/local/bigbluebutton/core/scripts/presentation.yml (in this comment webm and uncomment mp4)

cd /etc/cron.daily/ && wget https://www.dropbox.com/s/1a05hbiw72js9dg/delete-old-recordings.sh && chmod +x delete-old-recordings.sh && ll

```

---

- **Scalelite Configuration and Server Integration**

# docker exec -it scalelite-api /bin/sh

./bin/rake servers

./bin/rake servers:add[https://vc4.imanage-school.com/bigbluebutton/api,AfyYOFaAsLHhQ8zbHPhNJH1VNR5tib3lblOVZ9IBLM,2]

./bin/rake servers:enable[10dcb7b9-4bc5-4c4a-a32e-d3977f53b4ec]

./bin/rake servers:disable[id]

./bin/rake servers:remove[id]

./bin/rake servers:panic[id]

Edit the load-multiplier of a server

./bin/rake servers:loadMultiplier[b89f2c66-6753-4819-b8d5-47ff0e5c1112,3]

./bin/rake poll:all

./bin/rake status

---

######## **Using BigBlueButton servers through Scalelite :-**

Your BigBlueButton servers are now ready to be used. You can use Scalelite with any external application (such as Moodle or Wordpress) by setting its hostname as the BigBlueButton URL and the secret generated (LOADBALANCER_SECRET) during the installation as the BigBlueButton Secret.

https://meeting.imanage-school.com/bigbluebutton/api/

ff7b66bc4d2f8af0e5d90e5402994a9d6a7111f964665b2c

Copy your Load-balancer secret key from "cat scalelite-run/.env" file

---

---

*** END ***