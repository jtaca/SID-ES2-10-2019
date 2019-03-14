<?php
	// Get data
	echo "<h1>Migrations</h1>";
	echo "<p>-----------------------------------</p>";
	
	$url = "http://localhost/apiGet.php";		
	$client = curl_init($url);
	curl_setopt( $client, CURLOPT_POST, 1);
	curl_setopt( $client, CURLOPT_FOLLOWLOCATION, 1);
	curl_setopt( $client, CURLOPT_HEADER, 0);
	curl_setopt( $client, CURLOPT_RETURNTRANSFER, 1);
	$data = curl_exec($client);
	
	// Check if getting data was sucessful
	if (curl_errno($client)) {
		// this would be your first hint that something went wrong
		die('Couldn\'t send request: ' . curl_error($client));
	} else {
		// check the HTTP status code of the request
		$resultStatus = curl_getinfo($client, CURLINFO_HTTP_CODE);
		if ($resultStatus != 200) {
			// the request did not complete as expected. common errors are 4xx
			// (not found, bad request, etc.) and 5xx (usually concerning
			// errors/exceptions in the remote script execution)
			die('Request failed: HTTP status code: ' . $resultStatus);
		}
	}
	
	
	switch (json_last_error()) {
        case JSON_ERROR_NONE:
        break;
        case JSON_ERROR_DEPTH:
			printf(" - Maximum stack depth exceeded\n");
        break;
        case JSON_ERROR_STATE_MISMATCH:
			printf(" - Underflow or the modes mismatch\n");
        break;
        case JSON_ERROR_CTRL_CHAR:
			printf(" - Unexpected control character found\n");
        break;
        case JSON_ERROR_SYNTAX:
			printf(" - Syntax error, malformed JSON\n");
        break;
        case JSON_ERROR_UTF8:
			printf(" - Malformed UTF-8 characters, possibly incorrectly encoded\n");
        break;
        default:
			printf(" - Unknown error\n");
        break;
    }
	
	if(!empty(json_decode($data, true))) {
		echo '<pre>Data: ', json_encode(json_decode($data), JSON_PRETTY_PRINT), '</pre>';
		// Put data
		$url = "http://localhost/apiPut.php";
		$put = curl_init($url);
		curl_setopt( $put, CURLOPT_POST, 1);
		curl_setopt( $put, CURLOPT_POSTFIELDS, $data);
		curl_setopt( $put, CURLOPT_HTTPHEADER, array('Content-Type: application/json')); 
		curl_setopt( $put, CURLOPT_RETURNTRANSFER, 1);
		$last_updated = curl_exec($put);
		
		
		// Mark data as migrated
		markDataAsMigrated($last_updated);
	} else {
		echo "<p>No new or unmigrated data returned from server.</p>";
	}
	
	echo "-----------------------------------<br> Finished migrations...";

	
	function markDataAsMigrated($endID) {
		
		echo "<p> Marking data as Migrated:</p>";
		printf("End ID: ".$endID."<p>");
		
		// Database credentials
		$url="localhost";
		$username="root";
		$password="";
		$database="estufa";
		
		$conn = mysqli_connect($url, $username, $password, $database); // Connects to the mysql database. If unsuccessful $conn is an object that is false.
		
		if (!$conn){
			die ("Connection Failled: Couldn't mark data as migrated.");		// Prints a message and exits the current script
		}
		
		// Change character set to utf8
		if (!$conn->set_charset("utf8")) {
			printf("Error loading character set utf8: %s\n", $conn->error);
			exit();
		} else {
			printf("Current character set: %s\n", $conn->character_set_name());
		}
		
		$sql = "call updateMigrados(".$endID.")";	// sql string cronstructed. '.' concats strings
		$result = mysqli_query($conn, $sql);	// Performs the query on the database
		if($result) {
			echo "<p> Marking data as Migrated: Success</p>";
		}
	}	
	
?>