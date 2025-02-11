<?php
$host="localhost"; // Host name
$username="root"; // Mysql username
$db_password="devolity@1234web"; // Mysql password
$db_name="link_ip"; // Database name
$local_db = mysql_connect("$host", "$username", "$db_password")or die(mysql_error());
mysql_select_db("$db_name",$local_db)or die("cannot select DB");
?>

<html>
<body>
<a href="index.php"><img src="devolitymail-logo.jpg"></a>
<b><Marquee><u> devolity LOG'S MONITORING </u> </marquee></b>
<b><u>LINK IP BLACK-LIST</u> </b>

<?php
$result = mysql_query("select * from `lnklist_ip` where status=1");
//echo "found";die;
while($result_arr = mysql_fetch_array($result))
{
//echo "<br>{$result_arr['type']}<br>";
echo "<p><a href='http://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a".$result_arr['list_ip']."#'>".$result_arr['list_ip']."</a></p>";
}
?>

</html>
</body>

