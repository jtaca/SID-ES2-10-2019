	<?php
	$url="127.0.0.1";
	$database="estufa";
	$conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);

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