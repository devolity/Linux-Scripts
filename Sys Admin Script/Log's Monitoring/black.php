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
<b><Marquee><u> devolity LOG'S MONITORING </u> </marquee></b>
<br><a href="index.php"><img src="devolitymail-logo.jpg"></a></br>
<b><u> LINK SERVER IP BLACK-LIST STATUS </u></b>

<?php
$result = mysql_query("select * from `lnklist_ip` where status=1");
//echo "found";die;
$ip_array = array();
while($result_arr = mysql_fetch_array($result))
{
$ip_array[] = $result_arr['list_ip'];
//echo "<br>{$result_arr['type']}<br>";

}
$ip_string = implode($ip_array," ");
//echo "<br>***************<br>";
//die;
?>

<?php
echo "<br>";
$result = mysql_query("select * from `lnklist_ip` where status=1");
//echo "found";die;
while($result_arr = mysql_fetch_array($result))
{

//print_R($result_arr);
$url = "http://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a".$result_arr['list_ip'];
//echo "<p><a href='http://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a".$result_arr['ip_name']."#'>".$result_arr['ip_name']."</a></p>";
echo $result_arr['list_ip'];
echo "<br>";
echo "<iframe src='$url' width='100%' height='400px'></iframe>";
echo "<br>";
}
?>

</html>
</body>

