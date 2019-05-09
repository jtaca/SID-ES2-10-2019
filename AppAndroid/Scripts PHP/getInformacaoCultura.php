<?php
	$url="127.0.0.1";
	$database="estufa";
    $conn = mysqli_connect($url,$_POST['username'],$_POST['password'],$database);
	$valor=$_POST['idCultura'];
	$sql = "select NomeCultura,DescricaoCultura from cultura where IDCultura='$valor'";
	$result = mysqli_query($conn, $sql);
	$response["InformacaoCultura"] = array();
	if ($result){
		if (mysqli_num_rows($result)>0){
			while($r=mysqli_fetch_assoc($result)){
				$ad = array();
				$ad["nomeCultura"] = $r['NomeCultura'];
				$ad["descricaoCultura"] = $r['DescricaoCultura'];
				array_push($response["InformacaoCultura"], $ad);
			}
		}	
	}
	
	
	$json = json_encode($response["InformacaoCultura"]);
	echo $json;
	mysqli_close ($conn);