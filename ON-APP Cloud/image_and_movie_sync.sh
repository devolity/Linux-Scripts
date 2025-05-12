umount /dev/sdd1;
umount /dev/sde1;
umount /dev/sdf1;
/etc/init.d/autofs restart;
cd /backup;
ls;
cd /Image_Drive;
ls;
cd /Movie_Drive;
ls;
rsync -vrudlpt /share/imagerepos/2013-2014/ /Image_Drive/2013-2014/
rsync -vrudlpt /software/VideoShare/ /Movie_Drive
