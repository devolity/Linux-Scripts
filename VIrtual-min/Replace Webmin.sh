SERVICES = httpd, postfix, bind, quota_nld, proftpd, dovecot, htcacheclean, mysqld, awstats, 

For Creating Domain = --unix --dir --webmin --web --dns --mail --limits-from-plan

For Creating User =  --quota 100 --real "$vs.$un"

