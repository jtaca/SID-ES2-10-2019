	<?php
	$url="127.0.0.1";
	$database="estufa";
    $conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	//$username="joao";
    //$password="1234";
	//$conn = mysqli_connect($url,$username,$password,$database);
	$sql = "select DataHoraMedicao,ValorMedicaoLuminosidade from medicoes_luminosidade where DataHoraMedicao >= now() - interval 5 minute";
	$result = mysqli_query($conn, $sql);
	$response["medicoes"] = array();
	if ($result){
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				$ad = array();
				$ad["valorMedicaoLuminosidade"] = $r['ValorMedicaoLuminosidade'];
				$ad["dataHoraMedicao"] = $r['DataHoraMedicao'];
				array_push($response["medicoes"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["medicoes"]);
	echo $json;
	mysqli_close ($conn);