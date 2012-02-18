<?php
	// set up necessary variables for outputting calendar
	$date = getdate();
	$month = $date[month];
	$year = $date[year];
	if(!empty($_POST['month'])) {
		$date = getdate(mktime(0,0,0,$_POST['month'],1,$year));
		$month = $date[month];
		$year = $date[year];
	}
	$monthnum = $date[mon];
	$startdate = getdate(mktime(0,0,0,$monthnum,1,$year)); // timestamp corresponding to first day of current month
	$startday = $startdate[wday]; // day of the week for first day of month
	$daycount = 1; // to increment days in the month - obviously, starts at one
	$enddate = getdate(mktime(0,0,0,$monthnum+1,0,$year));
	$endday = $enddate[mday]; // day of the *month* for last day - to stop printing numbers to calendar
	$counter = 0; // to count events in current month
	
	// establish database connection
	$conn = mysql_connect('localhost', 'claytont', 'claytont');
	mysql_select_db("claytontDB", $conn);
	
	
?>

<html>
	<head>
		<title>Event Calendar</title>
		<style type="text/css">
			body {
				background-color: #000055;
				color: white;
				text-align: center;
			}
			a:link, a:visited {
				color: white;
			}
			table, td, th {
				border: 1px solid white;
				margin-left: auto;
				margin-right: auto;
			}
			span {
				display: none;
			}
		</style>
		<script type="text/javascript" src="eventcalendar.js">
		</script>
		<base target="_self" />
	</head>
	<body onload="registerEvents()">
		<form target="" method="post">
			<input type="hidden" name="month" id="month" value="<?php echo "$monthnum"; ?>">
			<h1>Event Calendar - <?php echo "$month $year"; ?></h1>
			<input type="submit" value="Previous Month" onclick="changeMonth(-1);">
			<input type="submit" value="Next Month" onclick="changeMonth(1);">
			<table>
				<thead>
					<tr>
						<th>Sunday</th>
						<th>Monday</th>
						<th>Tuesday</th>
						<th>Wednesday</th>
						<th>Thursday</th>
						<th>Friday</th>
						<th>Saturday</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<?php
							for($i = 0; $i < 42; $i++) {
								// output different table cells depending on day values
								if(($i < 7 && $i == $startday) || ($i < 7 && $daycount > 1) || ($i >= 7 && $daycount <= $endday)) {
									echo "<td>$daycount<br />";
									$sql = "select title, description from calendarentries where eventdate = '$year-$monthnum-$daycount'";
									$result = mysql_query($sql, $conn) or die(mysql_error());
									while($myArray = mysql_fetch_array($result)) {
										$title = $myArray['title'];
										$desc = $myArray['description'];
										echo "<a href='#' id='e$counter' name='$title'>$title <span>$desc</span></a><br />";
										$counter++;
									}
									echo "</td>";
									$daycount++;
								} elseif($i < 7 && $daycount <= 1) {
									echo "<td>&nbsp;</td>";
								} elseif($daycount > $endday) {
									// test if current day is Saturday, in which case we are finished with last row
									if(($i+1) % 7 == 0) {
										echo "<td>&nbsp;</td>";
										return; // exit b/c we're finished
									} else { // it's not Saturday yet, so continue printing empty cells
										echo "<td>&nbsp;</td>";
									}
								}
								// insert new row
								if(($i + 1) % 7 == 0) {
									echo "</tr><tr>";
								}
							}
						?>
					</tr>
				</tbody>
			</table>
		</form>
	</body>
</html>