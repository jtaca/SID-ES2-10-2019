<?php
	$url="127.0.0.1";
	$database="estufa";
    $conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	$data=$_POST['date'];
	$sql = "select data,nomeVariavel,limiteInferiorVar,limiteSuperiorVar,valor,descricaoAlertas from alertas where nomeCultura='todas' and DATE(data)= '$data'";
	$result = mysqli_query($conn, $sql);
	$response["AlertasGlobais"] = array();
	if ($result){
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				$ad = array();
				$ad["DataHora"] = $r['data'];
				$ad["NomeVariavel"] = $r['nomeVariavel'];
				$ad["LimiteInferior"] = $r['limiteInferiorVar'];
				$ad["LimiteSuperior"] = $r['limiteSuperiorVar'];
				$ad["ValorMedicao"] = $r['valor'];
				$ad["Descricao"] = $r['descricaoAlertas'];
				array_push($response["AlertasGlobais"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["AlertasGlobais"]);
	echo $json;
	mysqli_close ($conn);