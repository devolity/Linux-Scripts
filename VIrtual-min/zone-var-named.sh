zone "sm.sm.com" {
        type master;
        file "/var/named/sm.sm.com.hosts";
        allow-transfer {
                127.0.0.1;
                localnets;
                };
        };
zone "asdf" {
        type master;
        file "/var/named/asdf.hosts";
        allow-transfer {
                127.0.0.1;
                localnets;
                };
        };
zone "sdkdfsdf" {
        type master;
        file "/var/named/sdkdfsdf.hosts";
        allow-transfer {
                127.0.0.1;
                localnets;
                };
        };
zone "abhcshc.asdfgm.com" {
        type master;
        file "/var/named/abhcshc.asdfgm.com.hosts";
        allow-transfer {
                127.0.0.1;
                localnets;
                };
        };
##################IN Sm.sm.com.host file ####################
$ttl 38400
@       IN      SOA     machine299.com. root.machine299.com. (
                        1417929046
                        10800
                        3600
                        604800
                        38400 )
@       IN      NS      machine299.com.
sm.sm.com.      IN      A       192.3.159.188
www.sm.sm.com.  IN      A       192.3.159.188
ftp.sm.sm.com.  IN      A       192.3.159.188
m.sm.sm.com.    IN      A       192.3.159.188
localhost.sm.sm.com.    IN      A       127.0.0.1
webmail.sm.sm.com.      IN      A       192.3.159.188
admin.sm.sm.com.        IN      A       192.3.159.188
mail.sm.sm.com. IN      A       192.3.159.188
sm.sm.com.      IN      MX      5 mail.sm.sm.com.
sm.sm.com.      IN      TXT     "v=spf1 a mx a:sm.sm.com ip4:192.3.159.188 ?all"
#################IN ordanry user #########
$ttl 38400
@       IN      SOA     machine299.com. root.machine299.com. (
                        1418000453
                        10800
                        3600
                        604800
                        38400 )
@       IN      NS      machine299.com.
asdf.   IN      A       192.3.159.188
www.asdf.       IN      A       192.3.159.188
ftp.asdf.       IN      A       192.3.159.188
m.asdf. IN      A       192.3.159.188
localhost.asdf. IN      A       127.0.0.1
webmail.asdf.   IN      A       192.3.159.188
admin.asdf.     IN      A       192.3.159.188
mail.asdf.      IN      A       192.3.159.188
asdf.   IN      MX      5 mail.asdf.
asdf.   IN      TXT     "v=spf1 a mx a:asdf ip4:192.3.159.188 ?all"
##############


