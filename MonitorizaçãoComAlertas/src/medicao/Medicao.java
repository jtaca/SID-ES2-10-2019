package medicao;


import java.time.LocalDateTime;

import org.eclipse.paho.client.mqttv3.MqttMessage;

public class Medicao {
	private String timestamp;
	private double temperatura;
	private double luminosidade;
	private boolean alertaLuminosidade;
	private boolean alertaTemperatura;
	private boolean erroTemperatura;
	private boolean erroLuminosidade;
	private boolean exportadoParaOMongo;
	private String causaTemperatura;
	private String causaLuminosidade;
	
	public Medicao(MqttMessage message) {
		super();
		parseMessage(message);
		alertaLuminosidade = false;
		alertaTemperatura = false;
		erroTemperatura = false;
		erroLuminosidade = false;
		exportadoParaOMongo=false;
		causaLuminosidade="";
		causaTemperatura="";
	}
	

	
	/**
	 * Returns the attribute 'causaTemperatura' which indicates the cause of the alert.
	 * @return string causaTemperatura	 
	 */

	public String getCausaTemperatura() {
		return causaTemperatura;
	}


	public void setCausaTemperatura(String causaTemperatura) {
		this.causaTemperatura = causaTemperatura;
	}


	public String getCausaLuminosidade() {
		return causaLuminosidade;
	}


	public void setCausaLuminosidade(String causaLuminosidade) {
		this.causaLuminosidade = causaLuminosidade;
	}



	public void parseMessage(MqttMessage message) {

			String [] measures = message.toString().split(",");
			String temp = measures[0].substring(8, measures[0].length()-1);
			String[] lum = measures[4].toString().split("s");
			String res = lum[0].substring(8, lum[0].length()-2);
			this.timestamp = parseDate();
			this.temperatura = Double.parseDouble(temp);
			this.luminosidade = Integer.parseInt(res);
		
	}

	public void setAlertaLuminosidade(boolean alertaLuminosidade) {
		this.alertaLuminosidade = alertaLuminosidade;
	}


	public void setAlertaTemperatura(boolean alertaTemperatura) {
		this.alertaTemperatura = alertaTemperatura;
	}


	public void setErroTemperatura(boolean erroTemperatura) {
		this.erroTemperatura = erroTemperatura;
	}


	public String getTimestamp() {
		return timestamp;
	}


	public double getTemperatura() {
		return temperatura;
	}


	public double getLuminosidade() {
		return luminosidade;
	}


	public int isAlertaLuminosidade() {
		if(alertaLuminosidade){
			return 1;
		}else {
			return 0;
		}
	}


	public int isAlertaTemperatura() {
		if(alertaTemperatura){
			return 1;
		}else {
			return 0;
		}
	}


	public int isErroTemperatura() {
		if(erroTemperatura){
			return 1;
		}else {
			return 0;
		}
	}



	public int isErroLuminosidade() {
		if(erroLuminosidade){
			return 1;
		}else {
			return 0;
		}
	}


	public boolean isExportadoParaOMongo() {
		return exportadoParaOMongo;
	}


	public void setExportadoParaOMongo(boolean exportadoParaOMongo) {
		this.exportadoParaOMongo = exportadoParaOMongo;
	}


	public void setErroLuminosidade(boolean erroLuminosidade) {
		this.erroLuminosidade = erroLuminosidade;
	}
	
	public String parseDate() {
		String currentDate = LocalDateTime.now() +"";
		String replacedDate = currentDate.replace('T', ' ');
		return replacedDate.substring(0, replacedDate.length()-4);
		
	}
	
	

	@Override
	public String toString() {
		return "Medicao [timestamp=" + timestamp + ", temperatura=" + temperatura + ", luminosidade=" + luminosidade
				+ ", alertaLuminosidade=" + alertaLuminosidade + ", alertaTemperatura=" + alertaTemperatura
				+ ", erroTemperatura=" + erroTemperatura + ", erroLuminosidade=" + erroLuminosidade + "]";
	}
	
}
