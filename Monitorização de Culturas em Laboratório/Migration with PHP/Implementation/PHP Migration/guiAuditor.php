<!DOCTYPE html>
<html>
<body>

<style>
html, body {
	font-family: sans-serif;
	margin:0;
	padding: 0;
	color: #404040;
}

h1 {
	margin: 30px 10px;
    font-size: 50px;
    text-align: center;
}

h2 {
	margin-top: 0;
	margin-bottom: 20px;
}

.row {
	display: flex;
}

button {
	background-color: #629fde;
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    font-size: 16px;
	display: block;
	border-radius: 7px;
	box-shadow: 0px 3px 9px rgba(0,0,0,0.4);	
}

input[type=text] {
  border: 1px solid grey;
  border-radius: 5px;
  padding: 10px;
}

.floating-box, pre {
	box-shadow: 0px 3px 10px rgba(0,0,0,0.4);
	margin: 0 0 0 15px;
	border-radius: 10px;
    padding: 30px;
}

.floating-box.last {
	flex: 1;
	margin-right: 15px;
	padding-right: 10px;
}

.credentials-box, .query-box {
	display: inline-block;
}

.credentials-box label, .credentials-box input {
	display: block;
}

.credentials-box label, .query-box label {
	margin-bottom: 10px;
}

.credentials-box input.first, .query-box input {
	margin-bottom:15px;
}

.query-box {
	flex: 1;
	margin-left: 35px;
	margin-right: 20px;
}

.query-box label, .query-box input {
	display: block;
}

.query-box input {
	width: calc(100% - 20px);
}

pre {
	background-color: white;
	margin-right: 15px; 
	margin-top: 15px
}
</style>

	<h1> Auditoria de Dados </h1>
	<div class="row">
		<div class="floating-box">
			<h2> Ferramentas </h2>

			<form action="makeMigrations.php" method="get">
			  <button type="submit">Migrar manualmente</button>
			</form>
		</div>

		<div class="floating-box last">
			<h2> Consultar logs </h2>

			<form name="form" action="" method="get">

			<div class="row">
				<div class="credentials-box">
					<label>Nome de utilizador:</label>
					<input class="first" name="user" type="text"/>
					
					<label>Palavra-passe:</label>
					<input name="password" type="text"/>
				</div>

				<div class="query-box">
					<label>Comando SQL:</label>
					<input name="query" type="text"/>

					<div>
						<button style="float: right; margin-top: 20px" type="submit" name="execute">Executar</button>
					</div>
				</div>
			</div>
			
			</form>
		</div>
	</div>


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
			
			if (!$conn->set_charset("utf8")) {
				printf("Error loading character set utf8: %s\n", $conn->error);
				exit();
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
			echo "<pre> Please insert values into all fields in order to execute the query. </pre>";
		}
	}
	
?>
</body>		
</html>



