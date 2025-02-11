<?php
$host="localhost"; // Host name
$username="root"; // Mysql username
$db_password="devolity@1234web"; // Mysql password
$db_name="smtp_log"; // Database name
$local_db = mysql_connect("$host", "$username", "$db_password")or die(mysql_error());
mysql_select_db("$db_name",$local_db)or die("cannot select DB");
?>

<html>
<body>
<b><img src="devolitymail-logo.jpg">  
<b><Marquee><u> devolity LOG'S MONITORING </u> </marquee></b>
<br>
<div><b>
 <a href="index.php"> HOME </a> &nbsp;  &nbsp; 
 <a href="ping.php"> SMTP IP  PING</a>  &nbsp;  &nbsp;
 <a href="link.php"> LINK IP PING </a>  &nbsp;  &nbsp;
 <a href="ssmtp.php">SMTP IP BLACK-LIST </a>  &nbsp;  &nbsp;
 <a href="slink.php">LINK IP BLACK-LIST </a> &nbsp;  &nbsp;
 <a href="bulk.php">BULK IP BLACK-LIST </a> &nbsp;  &nbsp;
</b>
</div>
<div style="float:left; width:25%;">
</br>

<?php
echo "<br>";
$result = mysql_query("select * from `list_ip` where status=1");
//echo "found";die;
while($result_arr = mysql_fetch_array($result))
{
//echo "<br>{$result_arr['type']}<br>";
echo "<p><a href='http://103.255.101.34/".$result_arr['ip_name'].".txt'>".$result_arr['ip_name']."</a></p>";
}
?>

</div>
<div style="width:70%; float:right;">
<iframe src="http://103.255.101.34/cgi-bin/my.cgi"height="635px" width="60%" align="right" scrolling="auto" >
<p>Your browser does not support iframes.</p>
</iframe>
</div>
</html>
</body>
