echo -e "Have u entered the User Name in file /Scripts/Supporting_Files/list? \n In no, Please click CTRL+c and Enter ID in file first\n";
#echo "Please enter the Quota in Bytes";
#read quota;
echo "Please provide GroupName also.";
read grp;
for i in `cat /Scripts/Supporting_Files/list`
do
/usr/sbin/smbldap-useradd -a -m $i;
/usr/sbin/smbldap-passwd -p -B $i < /Scripts/Supporting_Files/password;
/usr/sbin/smbldap-usermod -g $grp $i
/usr/sbin/smbldap-groupmod -m $i $grp;
echo "ID: $i has been created with Password: default and group: $grp"; 
done
