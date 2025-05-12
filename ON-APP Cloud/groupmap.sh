echo "Enter the Group Name:"
read grp;
smbldap-groupadd $grp;
net groupmap add ntgroup="$grp" unixgroup="$grp"
echo "Entered group successfully added. Please check."
