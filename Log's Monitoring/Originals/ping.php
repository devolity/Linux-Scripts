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
<br><a href="index.php"><img src="devolitymail-logo.jpg"></a></br>
<b><u> SMTP IP PING STATUS </u></b>
<?php
$result = mysql_query("select * from `list_ip` where status=1");
//echo "found";die;
$ip_array = array();
while($result_arr = mysql_fetch_array($result))
{
$ip_array[] = $result_arr['ip_name'];
//echo "<br>{$result_arr['type']}<br>";

}
$ip_string = implode($ip_array," ");
//echo "<br>***************<br>";
//echo $ip_string;
//die;
?>

<?php
echo '<pre>';

// Outputs all the result of shellcommand "ls", and returns
// the last output line into $last_line. Stores the return value
// of the shell command in $retval.
system('fping '.$ip_string, $retval);

// Printing additional info
?>

</div>
</html>
</body>
