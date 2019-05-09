	<?php
	$url="127.0.0.1";
	$database="estufa";
	$username="joao";
	$password="1234";
    $conn = mysqli_connect($url,$username,$password,$database);
	//$conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	//$sql1= "select email from mysql.user where User=$username"
	//$result1 = mysqli_query($conn, $sql1);
	//$sql = "select IDCultura from cultura where EmailInvestigador=$result1";
	$sql = " SELECT IDCultura FROM cultura WHERE EmailInvestigador in (SELECT email FROM mysql.user WHERE User = '$username') ";
	$result = mysqli_query($conn, $sql);
	$response["AvailableIds"] = array();
	if ($result){
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				$ad = array();
				$ad["idCultura"] = $r['IDCultura'];
				array_push($response["AvailableIds"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["AvailableIds"]);
	echo $json;
	mysqli_close ($conn);