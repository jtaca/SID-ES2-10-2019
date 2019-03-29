<?php
	// Get data
	
	echo "<h1>Migrations</h1>";
	echo "<p>-----------------------------------</p>";
	
	printCurrentTimestamp("Started migrations");
	
	$url = "http://localhost/apiGet.php";		
	$client = curl_init($url);
	curl_setopt( $client, CURLOPT_POST, 1);
	curl_setopt( $client, CURLOPT_FOLLOWLOCATION, 1);
	curl_setopt( $client, CURLOPT_HEADER, 0);
	curl_setopt( $client, CURLOPT_RETURNTRANSFER, 1);
	$data = curl_exec($client);
	
	if (curl_errno($client)) { // Check if getting data was sucessful
		die('Couldn\'t send request: ' . curl_error($client));
	} else {
		$resultStatus = curl_getinfo($client, CURLINFO_HTTP_CODE); // check the HTTP status code of the request
		if ($resultStatus != 200) { // the request did not complete as expected.
			die('Request failed: HTTP status code: ' . $resultStatus);
		}
	}
	
	printCurrentTimestamp("Finished getting data. Started posting.");
	
	curl_close($client);
	
	if(!empty(json_decode($data, true))) {
		// Put data
		$url = "http://localhost/apiPut.php";
		$put = curl_init($url);
		curl_setopt( $put, CURLOPT_POST, 1);
		curl_setopt( $put, CURLOPT_POSTFIELDS, $data);
		curl_setopt( $put, CURLOPT_HTTPHEADER, array('Content-Type: application/json')); 
		curl_setopt( $put, CURLOPT_RETURNTRANSFER, 1);
		$last_updated = curl_exec($put);
		curl_close($put);
		
		printCurrentTimestamp("Finished putting data.");
		
		markDataAsMigrated($last_updated);
		
		printCurrentTimestamp("Finished migrations");
		
	} else {
		echo "<p>No new or unmigrated data returned from server.</p>";
	}
	
	echo "-----------------------------------<br> Finished migrations...";

	
	function markDataAsMigrated($endID) {
		printf("<p>Next updated ID: ".$endID);
		
		// Database credentials
		$url="localhost";
		$username="php";
		$password="php";
		$database="estufa";
		
		$conn = new mysqli($url, $username, $password, $database); // Connects to the mysql database. If unsuccessful $conn is an object that is false.
		
		if (!$conn){
			die ("Connection to original database failed: Couldn't mark data as migrated. Will retry on next migration.");		// Prints a message and exits the current script
		}
		
		// Change character set to utf8
		if (!$conn->set_charset("utf8")) {
			printf("<p>Error loading character set utf8: %s\n", $conn->error);
			exit();
		}
		
		$sql = "call updateMigrados(".$endID.")";	// sql string cronstructed. '.' concats strings
		$result = mysqli_query($conn, $sql);	// Performs the query on the database
		if($result) {
			echo "<p> Marking data as Migrated: Success</p>";
		} else {
			printf("<p>Unable to mark data as migrated");
		}
		
		$conn->next_result();
	}
	
	function printCurrentTimestamp($string) {
		$time = microtime(true);
		$dFormat = "l jS F, Y - H:i:s";
		$mSecs = $time - floor($time);
		$mSecs = substr($mSecs,1);
		
		echo '<br />';
		echo '<br />'.$string.' '.sprintf('%s%s', date($dFormat), $mSecs);
	}
	
?>