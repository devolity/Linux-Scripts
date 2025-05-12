for i in `cat /Scripts/Supporting_Files/list`
do
/usr/sbin/smbldap-passwd -B -p $i < /Scripts/Supporting_Files/password;
echo "Passwd set for $i: default"
done
