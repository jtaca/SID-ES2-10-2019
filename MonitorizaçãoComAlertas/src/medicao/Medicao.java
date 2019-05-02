package medicao;


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
	
	public Medicao(MqttMessage message) {
		super();
		parseMessage(message);
		alertaLuminosidade = false;
		alertaTemperatura = false;
		erroTemperatura = false;
		erroLuminosidade = false;
		exportadoParaOMongo=false;
	}
	

	public void parseMessage(MqttMessage message) {
		String [] measures = message.toString().split(",");
		String temp = measures[0].substring(8, measures[0].length()-1);
		String lum = measures[4].substring(8, measures[4].length()-14);
		String data= measures[2].substring(7, measures[2].length()-1);
		String hora = measures[3].substring(7, measures[3].length()-1);
		String ts = data + " "+ hora;
		this.timestamp = ts;
		this.temperatura = Double.parseDouble(temp);
		this.luminosidade = Integer.parseInt(lum);
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
	
	

	@Override
	public String toString() {
		return "Medicao [timestamp=" + timestamp + ", temperatura=" + temperatura + ", luminosidade=" + luminosidade
				+ ", alertaLuminosidade=" + alertaLuminosidade + ", alertaTemperatura=" + alertaTemperatura
				+ ", erroTemperatura=" + erroTemperatura + ", erroLuminosidade=" + erroLuminosidade + "]";
	}
	
}
