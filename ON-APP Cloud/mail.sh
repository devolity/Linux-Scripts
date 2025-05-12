rm -rf /Scripts/Supporting_Files/mail_output_copy;
ssh root@10.11.12.1 "/bin/echo -e '\nHi Team,\n\n\n1. Server Name: APPLICATION SERVER\n==================================\n\nDisk Space:\n----------'; /bin/df -h; /bin/echo -e '\nSwap Status:\n-----------';/usr/bin/free -m; /bin/echo -e '\nCurrent Load Average:\n--------------------';/usr/bin/uptime | /usr/bin/cut -d: -f5" >> /Scripts/Supporting_Files/mail_output_copy;
echo -e "\n\n\n...............................................................................................................\n\n\n\n2. Server Name: SERVER MANAGEMENT & FILE SHARING SERVER\n===========================================================\n\nDisk Space:\n----------" >> /Scripts/Supporting_Files/mail_output_copy;
df -h >> /Scripts/Supporting_Files/mail_output_copy;
echo -e "\nSwap Status:\n-----------" >> /Scripts/Supporting_Files/mail_output_copy;
free -m >> /Scripts/Supporting_Files/mail_output_copy;
echo -e "\nCurrent Load Average:\n--------------------">>/Scripts/Supporting_Files/mail_output_copy;
uptime | cut -d: -f5 >> /Scripts/Supporting_Files/mail_output_copy;
ssh root@10.11.12.4 "/bin/echo -e '\n\n\n\n3. Server Name: INTERNAL MAIL SERVER\n=======================================\n\nDisk Space:\n----------'; /bin/df -h; /bin/echo -e '\nSwap Status:\n-----------';/usr/bin/free -m; /bin/echo -e '\nCurrent Load Average:\n--------------------';/usr/bin/uptime | /usr/bin/cut -d: -f5" >> /Scripts/Supporting_Files/mail_output_copy;
echo -e "\n\n\nNote:- It is a Auto Generated Mail. So please don't reply\n">>/Scripts/Supporting_Files/mail_output_copy;
echo -e "\n\nThanks,\nDeepak Joshi - System Administrator">>/Scripts/Supporting_Files/mail_output_copy
cat /Scripts/Supporting_Files/mail_output_copy | mail -s "Alert: Server's Status" deepakj@gdgpsd.in jagpreetk@gdgpsd.in;
