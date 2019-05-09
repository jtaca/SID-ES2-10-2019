	<?php
	$url="127.0.0.1";
	$database="estufa";
    $conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	$sql = "select DataHoraMedicao,ValorMedicaoTemperatura from medicoes_temperatura where DataHoraMedicao >= now() - interval 5 minute";
	$result = mysqli_query($conn, $sql);
	$response["medicoest"] = array();
	if ($result){
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				$ad = array();
				$ad["valorMedicaoTemperatura"] = $r['ValorMedicaoTemperatura'];
				$ad["dataHoraMedicao"] = $r['DataHoraMedicao'];
				array_push($response["medicoest"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["medicoest"]);
	echo $json;
	mysqli_close ($conn);