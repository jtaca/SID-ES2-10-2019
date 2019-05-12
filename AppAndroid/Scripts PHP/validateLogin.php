	<?php
	$url="127.0.0.1";
	$database="estufa";
	$conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	//$conn = mysqli_connect($url,$username,$password,$database);
	//$response["valid"] = array();
	$response["valid"] = array();
	$json = json_encode($response["valid"]);
	echo $json;
	mysqli_close ($conn);