<?php
header("Content-Type: application/json;charset=utf-8");

//Make sure that it is a POST request.
if(strcasecmp($_SERVER['REQUEST_METHOD'], 'POST') != 0){
    throw new Exception('Request method must be POST!');
}
 
//Make sure that the content type of the POST request has been set to application/json
$contentType = isset($_SERVER["CONTENT_TYPE"]) ? trim($_SERVER["CONTENT_TYPE"]) : '';
if(strcasecmp($contentType, 'application/json') != 0){
    throw new Exception('Content type must be: application/json');
}

$data = trim(file_get_contents("php://input"));
$result = put_data($data);
echo $result;

function put_data($data){
	$logs = json_decode($data);
	
	if(!is_array($logs)){
		throw new Exception('Received content contained invalid JSON!');
	}
	
	// Database credentials
	$url="localhost";
	$database="auditor";
	$username="root";
	$password="";
	
	$conn = mysqli_connect($url, $username, $password, $database);
	/* change character set to utf8 */
	if (!$conn->set_charset("utf8")) {
		exit();
	}
	
	if ($conn){
		$sql = "call selectID";
		$result = mysqli_query($conn, $sql);
		$rows = array();
		
		// If the migrated db has data, next record is largest logId + 1
		if (mysqli_num_rows($result) > 0) {
			$r = mysqli_fetch_assoc($result);
			$next_record_id = $r["Maximo"] + 1;
		} else {
			$next_record_id = 1;
		}
		
		foreach ($logs as $log) {
			
			if ($log->logId >= $next_record_id) {
				$logId = $log->logId;
				$username = $log->username;
				$nomeTabela= $log->nomeTabela;
				$comandoUsado = $log->comandoUsado;
				$linhaAnterior = $log->linhaAnterior;
				$resultado = $log->resultado;
				$dataComando = $log->dataComando;
				
				$sql = "INSERT INTO logs (logId, comandoUsado, dataComando, linhaAnterior, nomeTabela, resultado, username)
						VALUES ('$logId','$comandoUsado','$dataComando','$linhaAnterior','$nomeTabela','$resultado','$username');";
				$res = mysqli_query($conn, $sql);
				if(!$res){
					$result = new stdClass();
					$result->status = false;
					$result->msg = mysqli_error($conn);
					echo json_encode($result);
					exit;
				}
				$next_record_id++;
			}
		}
		
		mysqli_close ($conn);
	}
	return $next_record_id;
}