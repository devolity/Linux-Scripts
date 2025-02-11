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
<b><Marquee><u> devolity LOG'S MONITORING </u> </marquee></b>
<b><img src="devolitymail-logo.jpg"> <p></b>
<?php
$result = mysql_query("select * from `list_ip` where status=1");
//echo "found";die;
while($result_arr = mysql_fetch_array($result))
{
//echo "<br>{$result_arr['type']}<br>";
echo "<p><a href='http://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a".$result_arr['ip_name']."#'>".$result_arr['ip_name']."</a></p>";
}
?>

</html>
</body>
