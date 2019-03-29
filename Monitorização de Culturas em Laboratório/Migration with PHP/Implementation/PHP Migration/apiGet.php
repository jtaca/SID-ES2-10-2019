<?php
header("Content-Type: application/json;charset=utf-8");

	$data = get_data();
	if(empty($data)){
		echo 'No unmigrated data found';
	} else{
		echo $data;
	}

function get_data() {
	// Database credentials
	$url="localhost";
	$database="estufa";
	$username="root";
	$password="";
	
	$conn = mysqli_connect($url, $username, $password, $database); // Connects to the mysql database. If unsuccessful $conn is an object that is false.
	/* change character set to utf8 */
	if (!$conn->set_charset("utf8")) {
		printf("Error loading character set utf8: %s\n", $conn->error);
		exit();
	}
	
	if (!$conn){
		die ("Connection Failled: ".$conn->connect_error);		// Prints a message and exits the current script
	}
	//call selectDadosNaoMigrados
	$sql = "select * from logs where exportado=0";	// sql query
	$result = mysqli_query($conn, $sql);	// Performs the query on the database
	$rows = array();	// Creates an empty array
	if ($result) {
		if (mysqli_num_rows($result)>0){			// Returns number of rows in the result set
			while($r=mysqli_fetch_assoc($result)){	// Returns an array that corresponds to the fetched row
				array_push($rows, $r);				// Pushes one or more elements onto the end of array
			}
		}
	}
	$result->close();
	$conn->next_result();
	$conn->close();             // Closes connection
	return json_encode($rows);	// Returns a string containing the JSON representation of the supplied value.
}