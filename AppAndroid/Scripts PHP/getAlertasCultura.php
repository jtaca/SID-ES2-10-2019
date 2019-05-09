<?php
	$url="127.0.0.1";
	$database="estufa";
    $conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	$valor1=$_POST['idCultura'];
	$valor2=$_POST['date'];
	
	$sql = "select data,nomeVariavel,limiteInferiorVar,limiteSuperiorVar,valor,descricaoAlertas from alertas where nomeCultura in (SELECT NomeCultura FROM cultura WHERE IDCultura = '$valor1') and data='$valor2'";
	$result = mysqli_query($conn, $sql);
	$response["AlertasCultura"] = array();
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
				array_push($response["AlertasCultura"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["AlertasCultura"]);
	echo $json;
	mysqli_close ($conn);