<!DOCTYPE html>
<html>
<body>

<h1> GUI Auditor </h1>
<h2> Efetuar migrações </h2>

<form action="makeMigrations.php" method="get">
  <input type="submit" value="Fazer migrações!">
</form>

<h2> Consultar logs </h2>

<form name="form" action="" method="get">

Username:<input name="user" type="text"/>
Password:<input name="password" type="text"/>

SQL Query:<input name="query" type="text"/>
<input type="submit" name="execute" value="execute" />
</form>


<?php
	
	if($_GET){
		if(!empty($_GET['user']) && !empty($_GET['query'])){
			$url="localhost";
			$username = $_GET['user'];
			$password = "".$_GET['password'];
			$database="auditor";
			$sql = $_GET['query'];
			
			$conn = mysqli_connect($url, $username, $password, $database); // Connects to the mysql database. If unsuccessful $conn is an object that is false.
			if (!$conn){
				die ("Connection Failled: Check your username and password, and try again.");		// Prints a message and exits the current script
			}
			$result = mysqli_query($conn, $sql);	// Performs the query on the database
			$rows = array();	// Creates an empty array
			if ($result) {
				if (mysqli_num_rows($result)>0){	// Returns number of rows in the result set
					while($r=mysqli_fetch_assoc($result)){	// Returns an array that corresponds to the fetched row
						array_push($rows, $r);	// Pushes one or more elements onto the end of array
					}
				}	
			}
			mysqli_close ($conn);	// Closes connection
			echo '<pre>', json_encode($rows, JSON_PRETTY_PRINT), '</pre>';	// Echoes a string containing a pretty representation of the supplied value.		
			
		} else {
			echo "Please insert values into all fields in order to execute the query.";
		}
	}
	
?>
</body>		
</html>



